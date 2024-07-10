import 'package:anchor/widgets/music_player.dart';
import 'package:flutter/material.dart';

class FavouritePage extends StatelessWidget {
  const FavouritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final albumSize = MediaQuery.of(context).size.width / 2;

    return Center(
      child: MusicPlayer(
        trackName: 'N/A',
        size: albumSize,
        isPlaying: false,
        onChangeState: (isPlaying) {
          print(isPlaying);
        },
      ),
    );
  }
}
