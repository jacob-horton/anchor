import 'package:anchor/models/audio_player.dart';
import 'package:anchor/widgets/music_player.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class TrackDetail {
  final String name;
  final int level;

  const TrackDetail({required this.name, required this.level});
}

class OtherMusicPage extends StatelessWidget {
  final TrackDetail trackDetail;

  static const levelToColour = [Colors.red, Colors.yellow, Colors.green];

  const OtherMusicPage({
    super.key,
    required this.trackDetail,
  });

  @override
  Widget build(BuildContext context) {
    final albumSize = MediaQuery.of(context).size.width / 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 64,
          height: 64,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                color: levelToColour[trackDetail.level - 1],
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: -1,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ),
        Consumer<AudioPlayerModel>(
          builder: (context, player, _) => MusicPlayer(
            size: albumSize,
            isPlaying: player.currentTrack == trackDetail.name,
            onChangeState: (isPlaying) async {
              player.switchOrPause(trackDetail.name);
            },
          ),
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: const SizedBox(
            width: 64,
            height: 64,
            child: HeroIcon(HeroIcons.star, size: 36, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
