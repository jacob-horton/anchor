import 'package:anchor/widgets/music_player.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class OtherMusicPage extends StatelessWidget {
  const OtherMusicPage({super.key});

  @override
  Widget build(BuildContext context) {
    final albumSize = MediaQuery.of(context).size.width / 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // TODO: does need gesture?
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: SizedBox(
            width: 64,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
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
        ),
        MusicPlayer(
          size: albumSize,
          isPlaying: false,
          onChangeState: (isPlaying) {
            print(isPlaying);
          },
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
