import 'package:anchor/widgets/music_player.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  final TrackDetail trackDetail;

  const FavouritePage({super.key, required this.trackDetail});

  @override
  Widget build(BuildContext context) {
    final albumSize = MediaQuery.of(context).size.width / 2;

    return Center(
      child: MusicPlayer(
        trackDetail: trackDetail,
        size: albumSize,
      ),
    );
  }
}
