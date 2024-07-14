import 'package:anchor/models/favourites.dart';
import 'package:anchor/widgets/music_player.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class TrackDetail {
  final String name;
  final int level;

  const TrackDetail({
    required this.name,
    required this.level,
  });
}

class OtherMusicPage extends StatelessWidget {
  final TrackDetail trackDetail;
  final void Function(int numFavourites) onFavouriteChanged;

  static const levelToColour = [Colors.red, Colors.yellow, Colors.green];

  const OtherMusicPage({
    super.key,
    required this.trackDetail,
    required this.onFavouriteChanged,
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
        MusicPlayer(
          size: albumSize,
          trackName: trackDetail.name,
        ),
        Consumer<FavouritesModel>(
          builder: (context, favourites, _) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (favourites.isFavourite(trackDetail.name)) {
                favourites.removeFavourite(trackDetail.name);
              } else {
                favourites.addFavourite(trackDetail.name);
              }

              onFavouriteChanged(favourites.favourites.length);
            },
            child: SizedBox(
              width: 64,
              height: 64,
              child: HeroIcon(
                HeroIcons.star,
                size: 36,
                color: Colors.white,
                style: favourites.isFavourite(trackDetail.name)
                    ? HeroIconStyle.solid
                    : HeroIconStyle.outline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
