import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  final void Function()? onClickBack;
  final void Function()? onClickForward;

  const FavouritePage({
    super.key,
    this.onClickBack,
    this.onClickForward,
  });

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    final circleSize = MediaQuery.of(context).size.width / 2;
    final buttonHitboxWidth = MediaQuery.of(context).size.width / 5;
    final buttonHitboxHeight = MediaQuery.of(context).size.height / 3;
    const buttonSize = 24.0;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (widget.onClickBack != null)
                GestureDetector(
                  onTap: widget.onClickBack,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: buttonHitboxWidth,
                    height: buttonHitboxHeight,
                    child: const Icon(Icons.arrow_left, size: buttonSize),
                  ),
                )
              else
                SizedBox(width: buttonHitboxWidth),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(circleSize / 5),
                      // border: Border.all(
                      //   color: Colors.red.withAlpha(100),
                      //   width: 10,
                      //   strokeAlign: BorderSide.strokeAlignOutside,
                      // ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 35),
                    child: Icon(Icons.pause, color: Colors.white, size: 48.0),
                  ),
                ],
              ),
              if (widget.onClickForward != null)
                GestureDetector(
                  onTap: widget.onClickForward,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: buttonHitboxWidth,
                    height: buttonHitboxHeight,
                    child: const Icon(Icons.arrow_right, size: buttonSize),
                  ),
                )
              else
                SizedBox(width: buttonHitboxWidth),
            ],
          ),
        ),
      ),
    );
  }
}
