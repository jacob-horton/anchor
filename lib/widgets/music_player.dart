import 'package:anchor/models/audio_player.dart';
import 'package:anchor/models/favourites.dart';
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

class MusicPlayer extends StatefulWidget {
  final double size;
  final TrackDetail trackDetail;
  final void Function(int numFavourites)? onFavouriteChanged;

  const MusicPlayer({
    super.key,
    required this.size,
    required this.trackDetail,
    this.onFavouriteChanged,
  });

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  static final levelColours = [
    [
      const Color(0xff83E78D),
      const Color(0xff65C76F),
    ],
    [
      const Color(0xffA8EFFF),
      const Color(0xff87A6F4),
    ],
    [
      const Color(0xffCEB7FF),
      const Color(0xffAF93FF),
    ],
  ];

  bool _isPlaying(AudioPlayerModel player) {
    return player.currentTrack == widget.trackDetail.name && player.isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: levelColours[widget.trackDetail.level - 1],
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  AudioPlayerModel.formatFilename(widget.trackDetail.name),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 1),
                        blurRadius: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<AudioPlayerModel>(
                  builder: (context, player, _) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() {
                      player.switchOrPause(
                        widget.trackDetail.name,
                        widget.trackDetail.level,
                      );
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: HeroIcon(
                        _isPlaying(player) ? HeroIcons.pause : HeroIcons.play,
                        color: Colors.white,
                        size: widget.size / 4,
                        style: HeroIconStyle.solid,
                      ),
                    ),
                  ),
                ),
                Consumer<FavouritesModel>(
                  builder: (context, favourites, _) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() {
                      if (favourites.isFavourite(widget.trackDetail.name)) {
                        favourites.removeFavourite(widget.trackDetail.name);
                      } else {
                        favourites.addFavourite(widget.trackDetail.name);
                      }

                      if (widget.onFavouriteChanged != null) {
                        widget.onFavouriteChanged!(
                          favourites.favourites.length,
                        );
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: HeroIcon(
                        HeroIcons.star,
                        style: favourites.isFavourite(widget.trackDetail.name)
                            ? HeroIconStyle.solid
                            : HeroIconStyle.outline,
                        color: Colors.white,
                        size: widget.size / 4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
