import 'dart:math';

import 'package:anchor/widgets/audio_progress_bar.dart';
import 'package:anchor/widgets/music_player.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class LevelPage extends StatelessWidget {
  final List<TrackDetail> trackDetails;
  final void Function(int numFavourites) onFavouriteChanged;

  const LevelPage({
    super.key,
    required this.trackDetails,
    required this.onFavouriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final displaySize = MediaQuery.of(context).size;
    final albumSize = min(displaySize.height / 6, displaySize.width / 2.75);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Level ${trackDetails[0].level}",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 25,
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: trackDetails
                  .slices(2)
                  .map(
                    (row) => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: row
                          .map(
                            (trackDetail) => Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: MusicPlayer(
                                trackDetail: trackDetail,
                                size: albumSize,
                                onFavouriteChanged: onFavouriteChanged,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                  .toList(),
            ),
            const AudioProgressBar(),
          ],
        ),
      ),
    );
  }
}
