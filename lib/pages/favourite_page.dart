import 'package:anchor/data/tracks.dart';
import 'package:anchor/widgets/audio_progress_bar.dart';
import 'package:anchor/widgets/track_player.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  final TrackDetail trackDetail;

  const FavouritePage({super.key, required this.trackDetail});

  @override
  Widget build(BuildContext context) {
    final albumSize = MediaQuery.of(context).size.width / 2;

    return Stack(
      children: [
        Center(
          child: TrackPlayer(
            trackDetail: trackDetail,
            size: albumSize,
          ),
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 40.0,
            ),
            child: AudioProgressBar(),
          ),
        ),
      ],
    );
  }
}
