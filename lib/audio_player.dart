import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioPlayer extends StatefulWidget {
  const MyAudioPlayer({super.key});

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  late AudioPlayer _player;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setAudioSource(
      AudioSource.asset('assets/audio/beki.mp3'),
      initialPosition: Duration.zero,
      preload: true,
    );

    _player.durationStream.listen((d) {
      if (d != null) {
        setState(() {
          duration = d;
        });
      }
    });

    _player.positionStream.listen((p) {
      setState(() {
        position = p;
      });
    });

    _player.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Slider(
            value: position.inMilliseconds.toDouble(),
            min: 0,
            max: duration.inMilliseconds.toDouble(),
            onChanged: (value) {
              _player.seek(Duration(milliseconds: value.toInt()));
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(position.toString().split('.').first),
              Text(duration.toString().split('.').first),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {}, // Implement skip previous
                icon: Icon(Icons.skip_previous_rounded, size: 40),
              ),
              IconButton(
                onPressed: () {
                  if (isPlaying) {
                    _player.pause();
                  } else {
                    _player.play();
                  }
                },
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  size: 60,
                ),
              ),
              IconButton(
                onPressed: () {
                  _player.stop();
                },
                icon: Icon(Icons.stop, size: 40),
              ),
              IconButton(
                onPressed: () {}, // Implement skip next
                icon: Icon(Icons.skip_next_rounded, size: 40),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
