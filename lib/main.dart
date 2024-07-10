import 'package:anchor/models/audio_player.dart';
import 'package:anchor/models/background.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/pages/end_page.dart';
import 'package:anchor/pages/favourite.dart';
import 'package:anchor/pages/other_music.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Anchor',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const tracks = [
    TrackDetail(name: 'breeze.mp3', level: 1),
    TrackDetail(name: 'change.mp3', level: 1),
    TrackDetail(name: 'difference.mp3', level: 1),
    TrackDetail(name: 'drifting.mp3', level: 1),
    TrackDetail(name: 'float.mp3', level: 1),
    TrackDetail(name: 'halls.mp3', level: 1),
    TrackDetail(name: 'homes.mp3', level: 1),
    TrackDetail(name: 'motions.mp3', level: 1),
    TrackDetail(name: 'openings.mp3', level: 1),
    TrackDetail(name: 'signs.mp3', level: 1),
    TrackDetail(name: 'sleepy.mp3', level: 1),
    TrackDetail(name: 'summer.mp3', level: 1),
    TrackDetail(name: 'trains.mp3', level: 1),
    TrackDetail(name: 'walks.mp3', level: 1),
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
    List<Widget> horizontalPages =
        List.generate(3, (i) => const FavouritePage());

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

    horizontalPages.add(
      PageView(
        controller: verticalController,
        onPageChanged: _handleVerticalPageChange,
        scrollDirection: Axis.vertical,
        children: verticalPages,
      ),
    );

    return ChangeNotifierProvider(
      create: (context) => BackgroundModel(),
      child: PageTemplate(
        onNavigateLeft: onNavigateLeft,
        onNavigateRight: onNavigateRight,
        onNavigateUp: onNavigateUp,
        onNavigateDown: onNavigateDown,
        body: ChangeNotifierProvider(
          create: (context) => AudioPlayerModel(),
          child: PageView(
            controller: controller,
            onPageChanged: _handleHorizontalPageChange,
            physics: horizontalScrollPhysics,
            children: horizontalPages,
          ),
        ),
      ),
    );
  }
}
