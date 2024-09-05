import 'dart:math';

import 'package:anchor/data/tracks.dart';
import 'package:anchor/models/audio_player.dart';
import 'package:anchor/models/background.dart';
import 'package:anchor/models/favourites.dart';
import 'package:anchor/models/hide_foreground.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/pages/end_page.dart';
import 'package:anchor/pages/favourite_page.dart';
import 'package:anchor/pages/level_page.dart';
import 'package:anchor/widgets/page_navigator.dart';
import 'package:anchor/widgets/placeholder_favourites_page.dart';
import 'package:anchor/widgets/welcome_message.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key, required this.title});
  final String title;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  final _horizontalController = PageController();
  final _verticalController = PageController();

  final _favouritesModel = FavouritesModel();
  final _audioPlayerModel = AudioPlayerModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    showWelcomeIfFirstLoad(context);

    final level1 = tracks.values.where((t) => t.level == 1);
    final level2 = tracks.values.where((t) => t.level == 2);
    final level3 = tracks.values.where((t) => t.level == 3);

    Iterable<Widget> verticalPages = [level1, level2, level3].map(
      (tracks) => LevelPage(
        trackDetails: tracks.toList(),

        // Make sure we scroll to the last page if we add/remove a favourite
        onFavouriteChanged: (numFavourites) {
          _horizontalController.jumpToPage(max(1, numFavourites));
        },
      ),
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
                (favourite) => FavouritePage(trackDetail: tracks[favourite]!),
              )
              .toList(),
          verticalPages: verticalPages.toList(),
          cornerPage: ChangeNotifierProvider(
            create: (context) => UsernameModel(),
            child: const EndPage(),
          ),
          placeholderHorizontalPage: const PlaceholderFavouritesPage(),
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
