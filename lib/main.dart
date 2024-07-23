import 'dart:math';

import 'package:anchor/models/audio_player.dart';
import 'package:anchor/models/background.dart';
import 'package:anchor/models/favourites.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/pages/end_page.dart';
import 'package:anchor/pages/favourite_page.dart';
import 'package:anchor/pages/level_page.dart';
import 'package:anchor/widgets/keep_alive.dart';
import 'package:anchor/widgets/music_player.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.jcode.anchor.channel.audio',
    androidNotificationChannelName: 'Anchor',
    androidNotificationOngoing: true,
  );

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

    return MaterialApp(
      title: 'Anchor',
      home: const HomePage(title: 'Flutter Demo Home Page'),
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          bodySmall: GoogleFonts.poppins(fontSize: 16.0),
          bodyMedium: GoogleFonts.poppins(fontSize: 20.0),
          titleMedium: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 36.0,
          ),
          titleSmall: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  static const _tracks = {
    // Level 1
    'breeze.ogg': TrackDetail(name: 'breeze.ogg', level: 1),
    'homes.ogg': TrackDetail(name: 'homes.ogg', level: 1),
    'openings.ogg': TrackDetail(name: 'openings.ogg', level: 1),
    'signs.mp3': TrackDetail(name: 'signs.mp3', level: 1),
    'warm.mp3': TrackDetail(name: 'warm.mp3', level: 1),

    // Level 2
    'change.ogg': TrackDetail(name: 'change.ogg', level: 2),
    'float.ogg': TrackDetail(name: 'float.ogg', level: 2),
    'sleepy.ogg': TrackDetail(name: 'sleepy.ogg', level: 2),
    'trains.ogg': TrackDetail(name: 'trains.ogg', level: 2),
    'walks.ogg': TrackDetail(name: 'walks.ogg', level: 2),

    // Level 3
    'difference.ogg': TrackDetail(name: 'difference.ogg', level: 3),
    'drifting.ogg': TrackDetail(name: 'drifting.ogg', level: 3),
    'halls.ogg': TrackDetail(name: 'halls.ogg', level: 3),
    'motions.ogg': TrackDetail(name: 'motions.ogg', level: 3),
    'summer.ogg': TrackDetail(name: 'summer.ogg', level: 3),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

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
      newNavDown = vertPage < 3; // 3 levels
    } else if (horizPage < max(1, _favouritesModel.favourites.length)) {
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
    final level1 = _tracks.values.where((t) => t.level == 1);
    final level2 = _tracks.values.where((t) => t.level == 2);
    final level3 = _tracks.values.where((t) => t.level == 3);

    Iterable<Widget> verticalPages = [level1, level2, level3].map(
      (tracks) => LevelPage(
          trackDetails: tracks.toList(),

          // Make sure we scroll to the last page if we add/remove a favourite
          onFavouriteChanged: (numFavourites) {
            _horizontalController.jumpToPage(max(1, numFavourites));
          }),
    );

    const animationDuration = Durations.medium4;
    const animationCurve = Curves.easeInOut;

    return ChangeNotifierProvider(
      create: (context) => BackgroundModel(),
      child: PageTemplate(
        onNavigateLeft: _navLeft
            ? () => _horizontalController.previousPage(
                duration: animationDuration, curve: animationCurve)
            : null,
        onNavigateRight: _navRight
            ? () => _horizontalController.nextPage(
                duration: animationDuration, curve: animationCurve)
            : null,
        onNavigateUp: _navUp
            ? () => _verticalController.previousPage(
                duration: animationDuration, curve: animationCurve)
            : null,
        onNavigateDown: _navDown
            ? () => _verticalController.nextPage(
                duration: animationDuration, curve: animationCurve)
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
                // Keep alive to ensure scroll position stays the same
                builder: (context, favourites, _) => KeepAlivePage(
                  child: PageView.builder(
                    onPageChanged: (i) {
                      // Skip page change if in level pages
                      // Any page changes there will be to jump to end
                      if ((_verticalController.page ?? 0) > 0) {
                        return;
                      }

                      // Only allow scrolling vertically when at end of horizontal
                      if (i == max(1, favourites.favourites.length)) {
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
                      if (favourites.favourites.isEmpty && i == 0) {
                        return Align(
                          alignment: Alignment.center,
                          child: Center(
                            child: GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                _horizontalController.jumpToPage(1);
                                _verticalController.jumpToPage(1);
                                _onPageChange();
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text(
                                  "Please add a favourite",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                    fontSize: 28.0,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.2),
                                        offset: const Offset(0, 2),
                                        blurRadius: 25,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      if (i == max(1, favourites.favourites.length)) {
                        return ChangeNotifierProvider(
                          create: (context) => UsernameModel(),
                          child: const EndPage(),
                        );
                      }

                      return FavouritePage(
                        trackDetail: _tracks[favourites.favourites[i]]!,
                      );
                    },
                    itemCount: max(1, favourites.favourites.length) + 1,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state != AppLifecycleState.detached) {
      return;
    }

    _audioPlayerModel.stop();
    _audioPlayerModel.dispose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
