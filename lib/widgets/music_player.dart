import 'package:anchor/models/audio_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrackDetail {
  final String name;
  final int level;

  const TrackDetail({
    required this.name,
    required this.level,
  });
}

class MusicPlayer extends StatefulWidget {
  final double size;
  final TrackDetail trackDetail;

  const MusicPlayer({
    super.key,
    required this.size,
    required this.trackDetail,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  static final levelColours = [
    [
      Colors.lightGreen,
      Colors.green,
    ],
    [
      Colors.cyan[200],
      Colors.blue,
    ],
    [
      const Color(0xfffce1f3),
      const Color(0xffffb0d4),
    ],
  ];

  bool _isPlaying(AudioPlayerModel player) {
    return player.currentTrack == widget.trackDetail.name && player.isPlaying;
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
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: levelColours[widget.trackDetail.level - 1]
                  .map((c) => c!)
                  .toList(),
            ),
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
          child: Center(child: Text(widget.trackDetail.name.split('.')[0])),
        ),
        Consumer<AudioPlayerModel>(
          builder: (context, player, _) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() {
              player.switchOrPause(widget.trackDetail.name);
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
