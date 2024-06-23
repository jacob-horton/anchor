import 'package:anchor/pages/end_page.dart';
import 'package:anchor/pages/favourite.dart';
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

  @override
  Widget build(BuildContext context) {
    List<Widget> horizontalPages = List.generate(3, (i) {
      return FavouritePage(
        onClickBack: i == 0
            ? null
            : () => controller.previousPage(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                ),
        onClickForward: () => controller.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
      );
    });

    List<Widget> verticalPages = List.generate(
      2,
      (_) => PageTemplate(
        onNavigateUp: () => verticalController.previousPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
        onNavigateDown: () => verticalController.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
        body: Center(
          child: Container(
            color: Colors.green,
            width: 100,
            height: 100,
          ),
        ),
      ),
    );

    verticalPages.insert(
      0,
      EndPage(
        onClickBack: () => controller.previousPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
        onClickForward: () => verticalController.nextPage(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        ),
      ),
    );

    horizontalPages.add(
      PageView(
        controller: verticalController,
        scrollDirection: Axis.vertical,
        children: verticalPages,
      ),
    );

    return PageView(
      controller: controller,
      children: horizontalPages,
    );
  }
}
