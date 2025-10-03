import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';
import 'package:volume_controller/volume_controller.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final Strategy _strategy = Strategy.P2P_STAR;
  final String _userName = "User_${DateTime.now().millisecondsSinceEpoch % 1000}";
  String _statusText = 'Ready';
  List<String> connectedDeviceIds = [];
  bool _isBroadcasting = false;

  @override
  void initState() {
    super.initState();
    _startAdvertisingAndListening();
  }

  void _onPayloadReceived(String endpointId, Payload payload) {
    if (payload.type == PayloadType.BYTES) {
      final message = String.fromCharCodes(payload.bytes!);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SosAlertReceivedScreen(alertType: message, fromUser: endpointId),
        ),
      );
    }
  }

  void _startAdvertisingAndListening() async {
    await [
      Permission.location,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.bluetoothAdvertise,
      Permission.nearbyWifiDevices,
    ].request();

    try {
      await Nearby().startAdvertising(
        _userName,
        _strategy,
        onConnectionInitiated: (id, info) {
          print("Connection initiated from: ${info.endpointName} ($id)");
          Nearby().acceptConnection(id, onPayLoadRecieved: _onPayloadReceived);
        },
        onConnectionResult: (id, status) {
          print("Advertising connection result: $status");
        },
        onDisconnected: (id) {
          print("Disconnected from: $id");
        },
      );
      if (mounted) {
        setState(() {
          _statusText = "Silently listening for SOS signals...";
        });
      }
    } catch (e) {
      print("Advertising error: $e");
    }
  }

  void _sendBroadcastSOS(String alertType) async {
    setState(() {
      _statusText = "SOS Sent! Broadcasting '$alertType' to nearby devices...";
      connectedDeviceIds.clear();
      _isBroadcasting = true;
    });

    try {
      await Nearby().startDiscovery(
        _userName,
        _strategy,
        onEndpointFound: (id, name, serviceId) {
          print("Discovered $name ($id), attempting to connect.");
          Nearby().requestConnection(
            _userName,
            id,
            onConnectionInitiated: (endpointId, info) {
              Nearby().acceptConnection(endpointId, onPayLoadRecieved: _onPayloadReceived);
            },
            onConnectionResult: (endpointId, status) {
              if (status == Status.CONNECTED) {
                print("Connected to $endpointId, sending '$alertType'.");
                final data = Uint8List.fromList(alertType.codeUnits);
                Nearby().sendBytesPayload(endpointId, data);
                if (mounted) {
                  setState(() {
                    connectedDeviceIds.add(endpointId);
                  });
                }
                Nearby().disconnectFromEndpoint(endpointId);
              }
            },
            onDisconnected: (endpointId) {
              print("Disconnected from $endpointId during SOS.");
            },
          );
        },
        onEndpointLost: (id) {
          print("Lost sight of device: $id");
        },
      );

      await Future.delayed(const Duration(seconds: 15));
      await Nearby().stopDiscovery();
      if (mounted) {
        setState(() {
          _statusText = "SOS broadcast finished. Alerted ${connectedDeviceIds.length} device(s).";
          _isBroadcasting = false;
        });
      }
    } catch (e) {
      print("Discovery/Broadcast error: $e");
    }
  }

  void _showSosOptions() {
    if (_isBroadcasting) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.child_care, color: Colors.red),
              title: const Text('Child Lost'),
              onTap: () {
                Navigator.pop(context);
                _sendBroadcastSOS("CHILD_LOST");
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services, color: Colors.red),
              title: const Text('Medical Emergency'),
              onTap: () {
                Navigator.pop(context);
                _sendBroadcastSOS("MEDICAL_EMERGENCY");
              },
            ),
            ListTile(
              leading: const Icon(Icons.security, color: Colors.red),
              title: const Text('Security Threat'),
              onTap: () {
                Navigator.pop(context);
                _sendBroadcastSOS("SECURITY_THREAT");
              },
            ),
            ListTile(
              leading: const Icon(Icons.business_center, color: Colors.orange),
              title: const Text('Lost Belonging'),
              onTap: () {
                Navigator.pop(context);
                _sendBroadcastSOS("LOST_BELONGING");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency SOS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AvatarGlow(
              animate: _isBroadcasting,
              glowColor: Colors.red,
              duration: const Duration(milliseconds: 2000),
              repeat: true,
              glowCount: 2,
              child: GestureDetector(
                onTap: _showSosOptions,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.red[700],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        spreadRadius: 8,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'SOS',
                      style: TextStyle(
                        fontSize: 48,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                _statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SosAlertReceivedScreen extends StatefulWidget {
  final String alertType;
  final String fromUser;
  const SosAlertReceivedScreen({super.key, required this.alertType, required this.fromUser});

  @override
  State<SosAlertReceivedScreen> createState() => _SosAlertReceivedScreenState();
}

class _SosAlertReceivedScreenState extends State<SosAlertReceivedScreen> {
  final _alarmPlayer = AudioPlayer();
  double _originalVolume = 0.5;

  @override
  void initState() {
    super.initState();
    VolumeController().getVolume().then((volume) {
      _originalVolume = volume;
    });
    _startAlarm();
  }

  Future<void> _startAlarm() async {
    try {
      bool? hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator ?? false) {
        Vibration.vibrate(pattern: [500, 1000], repeat: 0);
      }

      VolumeController().setVolume(1.0, showSystemUI: false);

      // Using a different AudioSource configuration for alarm stream
      final source = AudioSource.asset('assets/audio/alarm.mp3');
      await _alarmPlayer.setAudioSource(source, initialPosition: Duration.zero, preload: true);
      
      _alarmPlayer.setLoopMode(LoopMode.one);
      _alarmPlayer.play();
    } catch (e) {
      print("Error loading or playing alarm sound: $e");
    }
  }

  @override
  void dispose() {
    Vibration.cancel();
    _alarmPlayer.dispose();
    VolumeController().setVolume(_originalVolume, showSystemUI: false);
    super.dispose();
  }

  (IconData, String) _getAlertDetails() {
    switch (widget.alertType) {
      case "CHILD_LOST":
        return (Icons.child_care, "CHILD LOST ALERT");
      case "MEDICAL_EMERGENCY":
        return (Icons.medical_services, "MEDICAL EMERGENCY");
      case "SECURITY_THREAT":
        return (Icons.security, "SECURITY THREAT");
      case "LOST_BELONGING":
        return (Icons.business_center, "LOST BELONGING ALERT");
      default:
        return (Icons.warning_amber_rounded, "GENERAL ALERT RECEIVED");
    }
  }

  @override
  Widget build(BuildContext context) {
    final (icon, title) = _getAlertDetails();
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 120),
            const SizedBox(height: 32),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'From nearby user: ${widget.fromUser}',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red[900],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('DISMISS'),
            )
          ],
        ),
      ),
    );
  }
}
