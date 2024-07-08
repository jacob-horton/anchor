import 'package:flutter/material.dart';

class MusicPlayer extends StatefulWidget {
  final double size;
  final bool isPlaying;

  final void Function(bool isPlaying) onChangeState;

  const MusicPlayer({
    super.key,
    required this.size,
    required this.isPlaying,
    required this.onChangeState,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  late bool playing;

  @override
  void initState() {
    super.initState();

    playing = widget.isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(widget.size / 5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 25,
                spreadRadius: 5,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() {
            playing = !playing;
            widget.onChangeState(playing);
          }),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: Icon(
              playing ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 48.0,
            ),
          ),
        ),
      ],
    );
  }
}
