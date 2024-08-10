import 'dart:math';

import 'package:anchor/models/audio_player.dart';
import 'package:anchor/models/background.dart';
import 'package:anchor/models/favourites.dart';
import 'package:anchor/models/hide_foreground.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/pages/end_page.dart';
import 'package:anchor/pages/favourite_page.dart';
import 'package:anchor/pages/level_page.dart';
import 'package:anchor/widgets/track_player.dart';
import 'package:anchor/widgets/page_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  static const _keyIsFirstLoad = 'is-first-load';
  _showDialogIfFirstLoad(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLoaded = prefs.getBool(_keyIsFirstLoad) ?? true;

    if (!context.mounted) {
      return;
    }

    if (isFirstLoaded) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Welcome",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Hi, I hope you find the app useful. Anchor is an app that was designed to help neurodivergent people who are feeling anxious and/or nervous. The songs were made with the specific intention of being an 'anchor' for someone who is distressed. They feature repetitive melodies, rhythms and soft sounds to try and create a soothing and consistent environment. The app wont be for everyone, but I hope that it helps you in moments when things are overwhelming.",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 14.0),
                ),
                const SizedBox(height: 10.0),
                Text(
                  "Please swipe to the left and then swipe up to see the list of songs.",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontWeight: FontWeight.w700, fontSize: 14.0),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("Dismiss"),
                onPressed: () {
                  Navigator.of(context).pop();
                  prefs.setBool(_keyIsFirstLoad, false);
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _showDialogIfFirstLoad(context);

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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BackgroundModel()),
        ChangeNotifierProvider(create: (context) => HideForegroundModel()),
        ChangeNotifierProvider(create: (context) => _audioPlayerModel),
        ChangeNotifierProvider(create: (context) => _favouritesModel),
      ],
      child: Consumer<FavouritesModel>(
        builder: (context, favouritesModel, child) => PageNavigator(
          horizontalController: _horizontalController,
          verticalController: _verticalController,
          horizontalPages: favouritesModel.favourites
              .map(
                (favourite) => FavouritePage(
                  trackDetail: _tracks[favourite]!,
                ),
              )
              .toList(),
          verticalPages: verticalPages.toList(),
          cornerPage: ChangeNotifierProvider(
            create: (context) => UsernameModel(),
            child: const EndPage(),
          ),
          placeholderHorizontalPage: Align(
            alignment: Alignment.center,
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: Text(
                  "Please add a favourite",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
