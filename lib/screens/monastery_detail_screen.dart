import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:just_audio/just_audio.dart';
import 'package:bodhicompasssihtest/screens/video_player_screen.dart';

class MonasteryDetailScreen extends StatefulWidget {
  const MonasteryDetailScreen({super.key});

  @override
  State<MonasteryDetailScreen> createState() => _MonasteryDetailScreenState();
}

class _MonasteryDetailScreenState extends State<MonasteryDetailScreen> {
  final InAppLocalhostServer localhostServer = InAppLocalhostServer();
  final _audioPlayer = AudioPlayer();
  bool _isServerRunning = false;

  @override
  void initState() {
    super.initState();
    localhostServer.start().then((_) {
      if (mounted) {
        setState(() {
          _isServerRunning = true;
        });
      }
    });

    _audioPlayer.setAsset('assets/audio/guide.mp3');
  }

  @override
  void dispose() {
    localhostServer.close();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('360° Virtual Tour'),
      ),
      body: _isServerRunning
          ? InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri("http://localhost:8080/web_viewer/index.html"),
              ),
            )
          : const Center(child: CircularProgressIndicator()),
      
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "isl_video_btn",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const VideoPlayerScreen(
                    videoAssetPath: 'assets/videos/isl_guide.mp4',
                  ),
                ),
              );
            },
            label: const Text('ISL Guide'),
            icon: const Icon(Icons.sign_language),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "audio_guide_btn",
            onPressed: () {
              if (_audioPlayer.playing) {
                _audioPlayer.pause();
              } else {
                _audioPlayer.play();
              }
              setState(() {});
            },
            child: Icon(
              _audioPlayer.playing ? Icons.pause : Icons.play_arrow,
            ),
          ),
        ],
      ),
    );
  }
}