import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tirtha_suraksha/screens/video_player_screen.dart';

class MonasteryDetailScreen extends StatefulWidget {
  const MonasteryDetailScreen({super.key});

  @override
  State<MonasteryDetailScreen> createState() => _MonasteryDetailScreenState();
}

class _MonasteryDetailScreenState extends State<MonasteryDetailScreen> {
  final _audioPlayer = AudioPlayer();

  bool _areButtonsCollapsed = true; 

  @override
  void initState() {
    super.initState();
    _audioPlayer.setAsset('assets/audio/guide.mp3');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _toggleButtonPanel() {
    setState(() {
      _areButtonsCollapsed = !_areButtonsCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double panelWidth = 160.0;
    final double rightPosition = _areButtonsCollapsed ? -(panelWidth - 40) : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Live 360° Darshan'),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://truevirtualtours.com/panorama/97728/360view"),
            ),
            initialSettings: InAppWebViewSettings(
              mediaPlaybackRequiresUserGesture: false,
              allowsInlineMediaPlayback: true,
            ),
          ),
          
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            right: rightPosition,
            bottom: 16.0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FloatingActionButton.small(
                  heroTag: "toggle_btn",
                  onPressed: _toggleButtonPanel,
                  child: Icon(
                    _areButtonsCollapsed ? Icons.arrow_back_ios_new : Icons.arrow_forward_ios_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
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
                      label: const Text('ISL'),
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}