import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicapp/models/track.dart';

class PlayerScreen extends StatefulWidget {
  final Track track;
  const PlayerScreen({super.key, required this.track});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final player = AudioPlayer();
  bool isPlaying = true;
  bool isSpeedDouble = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    bindPlayer();
    player.play();
  }

  bindPlayer() async {
    await player.setUrl(widget.track.track_audioFile.toString());
    duration = player.duration!;
    setState(() {});
    player.positionStream.listen((event) {
      Duration temp = event;
      position = temp;
      setState(() {});
    });
  }

  playerAction() {
    if (isPlaying) {
      player.pause();
      isPlaying = false;
    } else {
      player.play();
      isPlaying = true;
    }
    setState(() {});
  }

  doubleSpeed() {
    player.setSpeed(2.0);
  }

  normalSpeed() {
    player.setSpeed(1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: () {
            player.stop();
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.pink,
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.track.track_coverImage.toString()),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),
          const _BackgroundFilter(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                  width: 200,
                  height: 200,
                  image:
                      NetworkImage(widget.track.track_coverImage.toString())),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.track.track_name.toString(),
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.track.artist_name.toString(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Slider(
                activeColor: Colors.pink,
                inactiveColor: Colors.pink.withOpacity(.5),
                value: position.inSeconds.toDouble(),
                min: 0,
                max: duration.inSeconds.toDouble(),
                onChanged: (value) async {
                  final seekPosition = Duration(seconds: value.toInt());
                  await player.seek(seekPosition);
                  setState(() {});
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          formatTime(position),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    IconButton(
                        iconSize: 60,
                        color: Colors.pink,
                        onPressed: playerAction,
                        icon: !isPlaying
                            ? const Icon(Icons.play_circle_outline)
                            : const Icon(Icons.pause_circle_outline)),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        child: Text(
                          formatTime(duration),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  if (isSpeedDouble) {
                    normalSpeed();
                    isSpeedDouble = false;
                  } else {
                    doubleSpeed();
                    isSpeedDouble = true;
                  }
                  setState(() {});
                },
                child: _speedButton(
                    isSpeedDouble ? Colors.pink : Colors.grey[700]),
              )
            ],
          )
        ],
      ),
    );
  }

  Container _speedButton(color) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Text(
          '2x',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  String formatTime(Duration value) {
    String twoDigit(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigit(value.inHours);
    final min = twoDigit(value.inMinutes.remainder(60));
    final sec = twoDigit(value.inSeconds.remainder(60));
    return [if (value.inHours > 0) hours, min, sec].join(":");
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.2)
            ],
            stops: const [
              0.0,
              0.4,
              0.6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              Colors.deepPurple.shade200,
              const Color.fromARGB(216, 69, 39, 160),
              Colors.deepPurple.shade800
            ])),
      ),
    );
  }
}
