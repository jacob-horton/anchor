import 'package:anchor/pages/end_page.dart';
import 'package:anchor/pages/favourite.dart';
import 'package:anchor/pages/other_music.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';

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

      if (page < 2) {
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

    List<Widget> verticalPages =
        List.generate(2, (_) => const OtherMusicPage());

    verticalPages.insert(
      0,
      const EndPage(),
    );

    // TODO: if vertical page >= 0.5, don't allow horizontal scroll
    horizontalPages.add(
      PageView(
        controller: verticalController,
        onPageChanged: _handleVerticalPageChange,
        scrollDirection: Axis.vertical,
        children: verticalPages,
      ),
    );

    return PageTemplate(
      onNavigateLeft: onNavigateLeft,
      onNavigateRight: onNavigateRight,
      onNavigateUp: onNavigateUp,
      onNavigateDown: onNavigateDown,
      body: PageView(
        controller: controller,
        onPageChanged: _handleHorizontalPageChange,
        physics: horizontalScrollPhysics,
        children: horizontalPages,
      ),
    );
  }
}
