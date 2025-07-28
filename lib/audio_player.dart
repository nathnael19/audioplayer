import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:two/cubit/audio_cubit.dart';

class MyAudioPlayer extends StatefulWidget {
  final String path;
  final String title;
  final String imageUrl;
  const MyAudioPlayer({
    super.key,
    required this.path,
    required this.title,
    required this.imageUrl,
  });

  @override
  State<MyAudioPlayer> createState() => _MyAudioPlayerState();
}

class _MyAudioPlayerState extends State<MyAudioPlayer> {
  @override
  void initState() {
    super.initState();
    context.read<AudioCubit>().load(widget.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                  child: BlocBuilder<AudioCubit, AudioState>(
                    builder: (context, state) {
                      final audioCubit = context.read<AudioCubit>();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 236,
                            height: 313,
                            child: Image.network(
                              widget.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ProgressBar(
                              barHeight: 6,
                              progress: state.position,
                              buffered: state.buffered,
                              total: state.duration,
                              onSeek: (newPosition) =>
                                  audioCubit.seek(newPosition),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Add previous track logic
                                },
                                icon: const Icon(
                                  Icons.skip_previous_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  final newPos =
                                      state.position -
                                      const Duration(seconds: 10);
                                  audioCubit.seek(
                                    newPos >= Duration.zero
                                        ? newPos
                                        : Duration.zero,
                                  );
                                },
                                icon: const Icon(
                                  Icons.replay_10,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  state.isPlaying
                                      ? audioCubit.pause()
                                      : audioCubit.play();
                                },
                                icon: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Color(0xff80011F),
                                  radius: 35,
                                  child: Center(
                                    child: Icon(
                                      state.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  final newPos =
                                      state.position +
                                      const Duration(seconds: 10);
                                  final target = newPos <= state.duration
                                      ? newPos
                                      : state.duration;
                                  audioCubit.seek(target);
                                },
                                icon: const Icon(
                                  Icons.forward_10,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Add next track logic
                                },
                                icon: const Icon(
                                  Icons.skip_next_rounded,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          _buildInteractionRow(),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "ክፍሎች",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return ListTile(
                                textColor: Colors.white,
                                leading: const CircleAvatar(),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
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
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInteractionRow() {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              Text("400", style: TextStyle(color: Colors.white)),
              SizedBox(width: 10),
              Icon(Icons.thumb_up, color: Colors.white, size: 30),
            ],
          ),
          Row(
            children: const [
              Text("20", style: TextStyle(color: Colors.white)),
              SizedBox(width: 10),
              Icon(Icons.message, color: Colors.white, size: 30),
            ],
          ),
          Row(
            children: const [
              Text("4", style: TextStyle(color: Colors.white)),
              SizedBox(width: 10),
              Icon(Icons.share, color: Colors.white, size: 30),
            ],
          ),
          const Icon(Icons.bookmark, color: Colors.white, size: 30),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xffEDE4E6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Text(
                "Tip Creator",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
