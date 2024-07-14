import 'package:anchor/models/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicPlayer extends StatefulWidget {
  final double size;

  // TODO: replace with album art
  final String trackName;

  const MusicPlayer({
    super.key,
    required this.size,
    required this.trackName,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  bool _isPlaying(AudioPlayerModel player) {
    return player.currentTrack == widget.trackName && player.isPlaying;
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
          // TODO: move pause button to here instead of stack?
          child: Center(child: Text(widget.trackName)),
        ),
        Consumer<AudioPlayerModel>(
          builder: (context, player, _) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() {
              player.switchOrPause(widget.trackName);
            }),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 35),
              child: Icon(
                _isPlaying(player) ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 48.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
