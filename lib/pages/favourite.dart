import 'package:anchor/widgets/music_player.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  // TODO: change to track album art
  final String trackName;

  const FavouritePage({super.key, required this.trackName});

  @override
  Widget build(BuildContext context) {
    final albumSize = MediaQuery.of(context).size.width / 2;

    return Center(
      child: MusicPlayer(
        trackName: trackName,
        size: albumSize,
      ),
    );
  }
}
