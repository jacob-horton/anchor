import 'dart:io';

import 'package:anchor/models/background.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class NavigatorDetails {
  final void Function()? onNavigate;
  final Alignment alignment;
  final HeroIcons icon;
  final Axis direction;

  NavigatorDetails({
    this.onNavigate,
    required this.alignment,
    required this.icon,
    required this.direction,
  });
}

class PageTemplate extends StatelessWidget {
  final Widget body;

  final void Function()? onNavigateLeft;
  final void Function()? onNavigateRight;
  final void Function()? onNavigateUp;
  final void Function()? onNavigateDown;

  const PageTemplate({
    super.key,
    required this.body,
    this.onNavigateLeft,
    this.onNavigateRight,
    this.onNavigateUp,
    this.onNavigateDown,
  });

  Iterable<Widget> _generateNavigators(BuildContext context) {
    const buttonThickness = 90.0;
    Size horizontalSize =
        Size(buttonThickness, MediaQuery.of(context).size.height / 3);
    Size verticalSize =
        Size(MediaQuery.of(context).size.width / 3, buttonThickness);

    return [
      NavigatorDetails(
        onNavigate: onNavigateLeft,
        alignment: Alignment.centerLeft,
        icon: HeroIcons.arrowLeftCircle,
        direction: Axis.horizontal,
      ),
      NavigatorDetails(
        onNavigate: onNavigateRight,
        alignment: Alignment.centerRight,
        icon: HeroIcons.arrowRightCircle,
        direction: Axis.horizontal,
      ),
      NavigatorDetails(
        onNavigate: onNavigateUp,
        alignment: Alignment.topCenter,
        icon: HeroIcons.arrowUpCircle,
        direction: Axis.vertical,
      ),
      NavigatorDetails(
        onNavigate: onNavigateDown,
        alignment: Alignment.bottomCenter,
        icon: HeroIcons.arrowDownCircle,
        direction: Axis.vertical,
      ),
    ].where((n) => n.onNavigate != null).map((n) {
      var size = n.direction == Axis.horizontal ? horizontalSize : verticalSize;

      return Align(
        alignment: n.alignment,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: n.onNavigate,
          child: SizedBox(
            width: size.width,
            height: size.height,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                ),
                HeroIcon(
                  n.icon,
                  size: 32.0,
                  style: HeroIconStyle.solid,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Consumer<BackgroundModel>(
            builder: (context, backgroundModel, _) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: backgroundModel.isAsset
                        ? AssetImage(backgroundModel.path)
                        : FileImage(File(backgroundModel.path)),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
          SafeArea(
            child: Stack(
              children: [
                body,
                ..._generateNavigators(context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
