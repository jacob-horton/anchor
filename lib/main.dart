import 'package:anchor/models/audio_player.dart';
import 'package:anchor/models/background.dart';
import 'package:anchor/models/favourites.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/pages/end_page.dart';
import 'package:anchor/pages/favourite.dart';
import 'package:anchor/pages/other_music.dart';
import 'package:anchor/widgets/keep_alive.dart';
import 'package:anchor/widgets/music_player.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AnchorApp());
}

class AnchorApp extends StatelessWidget {
  const AnchorApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return const MaterialApp(
      title: 'Anchor',
      home: HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _tracks = {
    // Level 1
    'homes.ogg': TrackDetail(name: 'homes.ogg', level: 1),
    'openings.ogg': TrackDetail(name: 'openings.ogg', level: 1),
    'breeze.ogg': TrackDetail(name: 'breeze.ogg', level: 1),
    'signs.mp3': TrackDetail(name: 'signs.mp3', level: 1),
    'warm.mp3': TrackDetail(name: 'warm.mp3', level: 1),

    // Level 2
    'trains.ogg': TrackDetail(name: 'trains.ogg', level: 2),
    'float.ogg': TrackDetail(name: 'float.ogg', level: 2),
    'change.ogg': TrackDetail(name: 'change.ogg', level: 2),
    'walks.ogg': TrackDetail(name: 'walks.ogg', level: 2),
    'sleepy.ogg': TrackDetail(name: 'sleepy.ogg', level: 2),

    // Level 3
    'halls.ogg': TrackDetail(name: 'halls.ogg', level: 3),
    'summer.ogg': TrackDetail(name: 'summer.ogg', level: 3),
    'motions.ogg': TrackDetail(name: 'motions.ogg', level: 3),
    'drifting.ogg': TrackDetail(name: 'drifting.ogg', level: 3),
    'difference.ogg': TrackDetail(name: 'difference.ogg', level: 3),
  };

  final _horizontalController = PageController();
  final _verticalController = PageController();

  final _favouritesModel = FavouritesModel();
  final _audioPlayerModel = AudioPlayerModel();

  ScrollPhysics? _verticalScrollPhysics = const NeverScrollableScrollPhysics();

  bool _navLeft = false;
  bool _navRight = true;
  bool _navUp = false;
  bool _navDown = false;

  void _onPageChange() {
    // Set navigation buttons
    bool newNavLeft = false;
    bool newNavRight = false;
    bool newNavUp = false;
    bool newNavDown = false;

    final horizPage = (_horizontalController.page ?? 0.0).round();
    final vertPage = (_verticalController.page ?? 0.0).round();
    if (vertPage != 0) {
      // We are scrolling vertically
      newNavUp = true;
      newNavDown = vertPage < _tracks.length;
    } else if (horizPage < _favouritesModel.favourites.length) {
      // We are scrolling horizontally
      newNavLeft = horizPage > 0;
      newNavRight = true;
    } else {
      // We are at end page
      newNavLeft = true;
      newNavDown = true;
    }

    setState(() {
      _navLeft = newNavLeft;
      _navRight = newNavRight;
      _navUp = newNavUp;
      _navDown = newNavDown;
    });
  }

  @override
  Widget build(BuildContext context) {
    Iterable<Widget> verticalPages = _tracks.values.map(
      (t) => OtherMusicPage(
        trackDetail: t,

        // Make sure we scroll to the last page if we add/remove a favourite
        onFavouriteChanged: (numFavourites) =>
            _horizontalController.jumpToPage(numFavourites),
      ),
    );

    return ChangeNotifierProvider(
      create: (context) => BackgroundModel(),
      child: PageTemplate(
        onNavigateLeft: _navLeft
            ? () => _horizontalController.previousPage(
                duration: Durations.short2, curve: Curves.easeInOut)
            : null,
        onNavigateRight: _navRight
            ? () => _horizontalController.nextPage(
                duration: Durations.short2, curve: Curves.easeInOut)
            : null,
        onNavigateUp: _navUp
            ? () => _verticalController.previousPage(
                duration: Durations.short2, curve: Curves.easeInOut)
            : null,
        onNavigateDown: _navDown
            ? () => _verticalController.nextPage(
                duration: Durations.short2, curve: Curves.easeInOut)
            : null,
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => _audioPlayerModel),
            ChangeNotifierProvider(create: (context) => _favouritesModel),
          ],
          child: PageView(
            scrollDirection: Axis.vertical,
            physics: _verticalScrollPhysics,
            controller: _verticalController,
            onPageChanged: (_) => _onPageChange(),
            children: [
              Consumer<FavouritesModel>(
                builder: (context, favourites, _) => KeepAlivePage(
                  child: PageView.builder(
                    onPageChanged: (i) {
                      // Only allow scrolling vertically when at end of horizontal
                      if (i == favourites.favourites.length) {
                        setState(() => _verticalScrollPhysics = null);
                      } else {
                        setState(() => _verticalScrollPhysics =
                            const NeverScrollableScrollPhysics());
                      }

                      // Update arrows
                      _onPageChange();
                    },
                    controller: _horizontalController,
                    itemBuilder: (context, i) {
                      if (i == favourites.favourites.length) {
                        return ChangeNotifierProvider(
                          create: (context) => UsernameModel(),
                          child: const EndPage(),
                        );
                      }

                      return FavouritePage(
                        trackDetail: _tracks[favourites.favourites[i]]!,
                      );
                    },
                    itemCount: favourites.favourites.length + 1,
                  ),
                ),
              ),
              ...verticalPages
            ],
          ),
        ),
      ),
    );
  }
}
