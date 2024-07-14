import 'package:anchor/models/audio_player.dart';
import 'package:anchor/models/background.dart';
import 'package:anchor/models/favourites.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/pages/end_page.dart';
import 'package:anchor/pages/favourite.dart';
import 'package:anchor/pages/other_music.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const AnchorApp());
}

class AnchorApp extends StatelessWidget {
  const AnchorApp({super.key});

  @override
  Widget build(BuildContext context) {
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
  static const tracks = [
    TrackDetail(name: 'breeze.ogg', level: 1),
    TrackDetail(name: 'change.ogg', level: 1),
    TrackDetail(name: 'difference.ogg', level: 1),
    TrackDetail(name: 'drifting.ogg', level: 1),
    TrackDetail(name: 'float.ogg', level: 1),
    TrackDetail(name: 'halls.ogg', level: 1),
    TrackDetail(name: 'homes.ogg', level: 1),
    TrackDetail(name: 'motions.ogg', level: 1),
    TrackDetail(name: 'openings.ogg', level: 1),
    TrackDetail(name: 'signs.mp3', level: 1),
    TrackDetail(name: 'sleepy.ogg', level: 1),
    TrackDetail(name: 'summer.ogg', level: 1),
    TrackDetail(name: 'trains.ogg', level: 1),
    TrackDetail(name: 'walks.ogg', level: 1),
    TrackDetail(name: 'warm.mp3', level: 1),
  ];

  final controller = PageController(initialPage: 0);
  final verticalController = PageController(initialPage: 0);

  ScrollPhysics? horizontalScrollPhysics;

  void Function()? onNavigateLeft;
  void Function()? onNavigateRight;
  void Function()? onNavigateUp;
  void Function()? onNavigateDown;

  @override
  void initState() {
    super.initState();
    _handleHorizontalPageChange(0);
  }

  void _handleHorizontalPageChange(int page) {
    setState(() {
      onNavigateLeft = null;
      onNavigateRight = null;
      onNavigateUp = null;
      onNavigateDown = null;

      if (page < 3) {
        if (page >= 1) {
          onNavigateLeft = () => controller.previousPage(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
        }

        onNavigateRight = () => controller.nextPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
      }

      if (page == 3) {
        _handleVerticalPageChange(0);
      }
    });
  }

  void _handleVerticalPageChange(int page) {
    setState(() {
      onNavigateLeft = null;
      onNavigateRight = null;
      onNavigateUp = null;
      onNavigateDown = null;

      if (page == 0) {
        onNavigateLeft = () => controller.previousPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );

        horizontalScrollPhysics = null;
      } else {
        onNavigateUp = () => verticalController.previousPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );

        horizontalScrollPhysics = const NeverScrollableScrollPhysics();
      }

      if (page < tracks.length) {
        onNavigateDown = () => verticalController.nextPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
            );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> verticalPages = [
      ChangeNotifierProvider(
        create: (context) => UsernameModel(),
        child: const EndPage(),
      ),
    ];

    verticalPages.insertAll(
      1,
      tracks.map(
        (t) => OtherMusicPage(trackDetail: t),
      ),
    );

    Widget endVerticalPage = PageView(
      controller: verticalController,
      onPageChanged: _handleVerticalPageChange,
      scrollDirection: Axis.vertical,
      children: verticalPages,
    );

    return ChangeNotifierProvider(
      create: (context) => BackgroundModel(),
      child: PageTemplate(
        onNavigateLeft: onNavigateLeft,
        onNavigateRight: onNavigateRight,
        onNavigateUp: onNavigateUp,
        onNavigateDown: onNavigateDown,
        body: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => AudioPlayerModel()),
            ChangeNotifierProvider(create: (context) => FavouritesModel()),
          ],
          child: Consumer<FavouritesModel>(
            builder: (context, favourites, child) {
              // TODO: handle when empty
              Iterable<Widget> horizontalPages = favourites.favourites.map(
                (f) => FavouritePage(trackName: f),
              );

              // TODO: have vertical pages in completely separate widget (have page view for [horizontal page view, vertical page view])
              return PageView(
                controller: controller,
                onPageChanged: _handleHorizontalPageChange,
                physics: horizontalScrollPhysics,
                children: [...horizontalPages, child!],
              );
            },
            child: endVerticalPage,
          ),
        ),
      ),
    );
  }
}
