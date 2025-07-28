import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two/audio_player.dart';
import 'package:two/cubit/audio_cubit.dart';
import 'package:two/overlay_play.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List tracks = [
    [
      "Track 1",
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3",
      "https://i.pinimg.com/originals/62/e2/0a/62e20a91444dfb123bdd9a9acd1e6842.png",
    ],
    [
      "Track 2",
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3",
      "https://cdn.pixabay.com/photo/2023/03/25/20/30/podcast-7876792_1280.jpg",
    ],
    [
      "Track 3",
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3",
      "https://st.depositphotos.com/1008768/4671/i/450/depositphotos_46718315-stock-illustration-podcast.jpg",
    ],
  ];
  @override
  Widget build(BuildContext context) {
    final audioCubit = BlocProvider.of<AudioCubit>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffAA2424),
        foregroundColor: Colors.white,
        title: Text("Music Player"),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xffAA2424), Color(0xff000011)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: tracks.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyAudioPlayer(
                                  path: tracks[index][1],
                                  imageUrl: tracks[index][2],
                                  title: tracks[index][0],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(tracks[index][2]),
                              ),
                            ),
                            child: Text(
                              tracks[index][0],
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          OverlayPlay(),
        ],
      ),
    );
  }
}
