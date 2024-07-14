import 'package:anchor/widgets/music_player.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class LevelPage extends StatelessWidget {
  final List<TrackDetail> trackDetails;
  final void Function(int numFavourites) onFavouriteChanged;

  static const levelToColour = [Colors.red, Colors.yellow, Colors.green];

  const LevelPage({
    super.key,
    required this.trackDetails,
    required this.onFavouriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    final albumSize = MediaQuery.of(context).size.width / 2.75;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Level ${trackDetails[0].level}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 20.0),
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
                              padding: const EdgeInsets.all(10.0),
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
          ],
        ),
      ),
    );
  }
}
