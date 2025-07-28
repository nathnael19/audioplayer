import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

class MyAudioPlayer extends StatefulWidget {
  final String path;
  const MyAudioPlayer({super.key, required this.path});

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  late AudioPlayer _player;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  Duration buffered = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    _player = AudioPlayer();

    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(widget.path)),
        initialPosition: Duration.zero,
        preload: true,
      );

      _player.durationStream.listen((d) {
        if (d != null) {
          setState(() => duration = d);
        }
      });

      _player.positionStream.listen((p) {
        setState(() => position = p);
      });

      _player.bufferedPositionStream.listen((b) {
        setState(() => buffered = b);
      });

      _player.playerStateStream.listen((state) {
        setState(() => isPlaying = state.playing);
      });
    } catch (e) {
      debugPrint('Error loading audio: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player'),
        backgroundColor: const Color(0xffAA2424),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xffAA2424), Color(0xff000011)],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 236,
                        height: 313,
                        child: const Center(
                          child: Icon(
                            Icons.music_note,
                            size: 100,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ProgressBar(
                          barHeight: 6,
                          progress: position,
                          buffered: buffered,
                          total: duration,
                          onSeek: (newPosition) => _player.seek(newPosition),
                          timeLabelTextStyle: const TextStyle(
                            color: Colors.white,
                          ),
                          thumbColor: Colors.white,
                          baseBarColor: const Color(0xffE9E9E9),
                          progressBarColor: Colors.white,
                          bufferedBarColor: const Color.fromARGB(
                            255,
                            178,
                            181,
                            182,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      playPauseControls(),
                      const SizedBox(height: 24),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return ListTile(
                            textColor: Colors.white,
                            leading: CircleAvatar(),
                            trailing: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.download_for_offline,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            title: Text(
                              "Track ${index + 1}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("sub ${index + 1}"),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Row playPauseControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () {
            // Add previous track logic
          },
          icon: const Icon(
            Icons.skip_previous_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            final current = _player.position;
            final target = current - const Duration(seconds: 10);
            _player.seek(target >= Duration.zero ? target : Duration.zero);
          },
          icon: const Icon(Icons.replay_10, size: 40, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            isPlaying ? _player.pause() : _player.play();
          },
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: 80,
            color: Colors.white,
          ),
        ),
        IconButton(
          onPressed: () {
            final current = _player.position;
            final target = current + const Duration(seconds: 10);
            final newTarget = target <= duration ? target : duration;
            _player.seek(newTarget);
          },
          icon: const Icon(Icons.forward_10, size: 40, color: Colors.white),
        ),
        IconButton(
          onPressed: () {
            // Add next track logic
          },
          icon: const Icon(
            Icons.skip_next_rounded,
            size: 40,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
