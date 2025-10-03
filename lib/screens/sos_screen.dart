import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:just_audio/just_audio.dart';
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
      if (message == "SOS_ALERT") {
        print("SOS Message Received from $endpointId");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SosAlertReceivedScreen(fromUser: endpointId),
          ),
        );
      }
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
      if(mounted) {
        setState(() {
          _statusText = "Silently listening for SOS signals...";
        });
      }
    } catch (e) {
      print("Advertising error: $e");
    }
  }

  void _sendBroadcastSOS() async {
    setState(() {
      _statusText = "SOS Sent! Broadcasting to nearby devices...";
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
                print("Connected to $endpointId, sending SOS.");
                final data = Uint8List.fromList("SOS_ALERT".codeUnits);
                Nearby().sendBytesPayload(endpointId, data);
                if(mounted) {
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
      if(mounted) {
        setState(() {
          _statusText = "SOS broadcast finished. Alerted ${connectedDeviceIds.length} device(s).";
          _isBroadcasting = false;
        });
      }

    } catch (e) {
      print("Discovery/Broadcast error: $e");
    }
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
                onTap: _sendBroadcastSOS,
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
  final String fromUser;
  const SosAlertReceivedScreen({super.key, required this.fromUser});

  @override
  State<SosAlertReceivedScreen> createState() => _SosAlertReceivedScreenState();
}

class _SosAlertReceivedScreenState extends State<SosAlertReceivedScreen> {
  final _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _startAlarm();
  }

  Future<void> _startAlarm() async {
    try {
      // Set the audio file and make it loop
      await _audioPlayer.setAsset('assets/audio/alarm.mp3');
      await _audioPlayer.setLoopMode(LoopMode.one);
      // Play the sound
      _audioPlayer.play();
    } catch (e) {
      print("Error loading or playing alarm sound: $e");
    }
  }

  @override
  void dispose() {
    // Stop and release the player when the screen is closed
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 120),
            const SizedBox(height: 32),
            const Text(
              'EMERGENCY SOS RECEIVED',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'From nearby user: ${widget.fromUser}', // Use widget.fromUser
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