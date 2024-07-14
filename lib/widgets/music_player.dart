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
      Colors.lightGreen,
      Colors.green,
    ],
    [
      Colors.cyan[200],
      Colors.blue,
    ],
    [
      const Color(0xfffce1f3),
      const Color(0xffffb0d4),
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
          colors: levelColours[widget.trackDetail.level - 1]
              .map((c) => c!)
              .toList(),
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
      // TODO: move pause button to here instead of stack?
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Text(
              widget.trackDetail.name.split('.')[0],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Consumer<AudioPlayerModel>(
                builder: (context, player, _) => GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() {
                    player.switchOrPause(widget.trackDetail.name);
                  }),
                  child: HeroIcon(
                    _isPlaying(player) ? HeroIcons.pause : HeroIcons.play,
                    color: Colors.white,
                    size: widget.size / 4,
                    style: HeroIconStyle.solid,
                  ),
                ),
              ),
              if (widget.onFavouriteChanged != null)
                Consumer<FavouritesModel>(
                  builder: (context, favourites, _) => GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => setState(() {
                      if (favourites.isFavourite(widget.trackDetail.name)) {
                        favourites.removeFavourite(widget.trackDetail.name);
                      } else {
                        favourites.addFavourite(widget.trackDetail.name);
                      }

                      widget.onFavouriteChanged!(favourites.favourites.length);
                    }),
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
            ],
          ),
        ],
      ),
    );
  }
}
