import 'dart:math';

import 'package:anchor/models/hide_foreground.dart';
import 'package:anchor/widgets/keep_alive.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum PageType {
  leftMostHortizontal,
  hortizontal,
  corner,
  vertical,
  bottomMostVertical,
}

class _Navigators {
  void Function()? left;
  void Function()? right;
  void Function()? up;
  void Function()? down;

  _Navigators({this.left, this.right, this.up, this.down});
}

class PageNavigator extends StatefulWidget {
  final PageController horizontalController;
  final PageController verticalController;

  final List<Widget> horizontalPages;
  final List<Widget> verticalPages;
  final Widget cornerPage;
  final Widget placeholderHorizontalPage;

  const PageNavigator({
    super.key,
    required this.horizontalPages,
    required this.verticalPages,
    required this.cornerPage,
    required this.horizontalController,
    required this.verticalController,
    required this.placeholderHorizontalPage,
  });

  @override
  State<PageNavigator> createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  static const _animationDuration = Durations.medium4;
  static const _animationCurve = Curves.easeInOut;

  get navLeft => () => widget.horizontalController
      .previousPage(duration: _animationDuration, curve: _animationCurve);
  get navRight => () => widget.horizontalController
      .nextPage(duration: _animationDuration, curve: _animationCurve);
  get navUp => () => widget.verticalController
      .previousPage(duration: _animationDuration, curve: _animationCurve);
  get navDown => () => widget.verticalController
      .nextPage(duration: _animationDuration, curve: _animationCurve);

  _Navigators getNavigators(PageType pageType, bool hideForeground) {
    if (hideForeground && pageType == PageType.corner) {
      return _Navigators();
    }

    switch (pageType) {
      case PageType.leftMostHortizontal:
        return _Navigators(right: navRight);
      case PageType.hortizontal:
        return _Navigators(left: navLeft, right: navRight);
      case PageType.corner:
        return _Navigators(left: navLeft, down: navDown);
      case PageType.vertical:
        return _Navigators(up: navUp, down: navDown);
      case PageType.bottomMostVertical:
        return _Navigators(up: navUp);
    }
  }

  ScrollPhysics? _verticalScrollPhysics = const NeverScrollableScrollPhysics();

  PageType _pageType = PageType.leftMostHortizontal;

  void _onPageChange() {
    // Set navigation buttons
    PageType newPageType;

    final horizPage = (widget.horizontalController.page ?? 0.0).round();
    final vertPage = (widget.verticalController.page ?? 0.0).round();
    if (vertPage != 0) {
      // We are scrolling vertically
      if (vertPage < 3) {
        newPageType = PageType.vertical;
      } else {
        newPageType = PageType.bottomMostVertical;
      }
    } else if (horizPage < max(1, widget.horizontalPages.length)) {
      // We are scrolling horizontally
      if (horizPage > 0) {
        newPageType = PageType.hortizontal;
      } else {
        newPageType = PageType.leftMostHortizontal;
      }
    } else {
      // We are at corner page
      newPageType = PageType.corner;
    }

    setState(() => _pageType = newPageType);

    // Unfocus text fields
    FocusScope.of(context).focusedChild?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HideForegroundModel>(
      builder: (context, hideForegroundModel, child) {
        _Navigators navigators =
            getNavigators(_pageType, hideForegroundModel.hideForeground);

        return PageTemplate(
          onNavigateLeft: navigators.left,
          onNavigateRight: navigators.right,
          onNavigateUp: navigators.up,
          onNavigateDown: navigators.down,
          body: child!,
        );
      },
      child: PageView(
        scrollDirection: Axis.vertical,
        physics: _verticalScrollPhysics,
        controller: widget.verticalController,
        onPageChanged: (_) => _onPageChange(),
        children: [
          KeepAlivePage(
            child: PageView.builder(
              onPageChanged: (i) {
                // Skip page change if in level pages
                // Any page changes there will be to jump to end
                if ((widget.verticalController.page ?? 0) > 0) {
                  return;
                }

                // Only allow scrolling vertically when at end of horizontal
                if (i == max(1, widget.horizontalPages.length)) {
                  setState(() => _verticalScrollPhysics = null);
                } else {
                  setState(() => _verticalScrollPhysics =
                      const NeverScrollableScrollPhysics());
                }

                // Update arrows
                _onPageChange();
              },
              controller: widget.horizontalController,
              itemBuilder: (context, i) {
                if (widget.horizontalPages.isEmpty && i == 0) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      widget.horizontalController.jumpToPage(1);
                      widget.verticalController.jumpToPage(1);
                      _onPageChange();
                    },
                    child: widget.placeholderHorizontalPage,
                  );
                }

                if (i == max(1, widget.horizontalPages.length)) {
                  return widget.cornerPage;
                }

                return widget.horizontalPages[i];
              },
              itemCount: max(1, widget.horizontalPages.length) + 1,
            ),
          ),
          ...widget.verticalPages,
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Re-show bars
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    super.dispose();
  }
}
