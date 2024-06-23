import 'package:anchor/pages/settings.dart';
import 'package:flutter/material.dart';

class EndPage extends StatefulWidget {
  final void Function()? onClickBack;
  final void Function()? onClickForward;

  const EndPage({
    super.key,
    this.onClickBack,
    this.onClickForward,
  });

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  @override
  Widget build(BuildContext context) {
    final circleSize = MediaQuery.of(context).size.width / 2;
    final buttonHitboxWidth = MediaQuery.of(context).size.width / 5;
    final buttonHitboxHeight = MediaQuery.of(context).size.height / 3;
    const buttonSize = 24.0;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(30),
                    child: Text(
                      "Jacob",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
                    ),
                    child: const SizedBox(
                      width: 80,
                      height: 70,
                      // color: Colors.red,
                      child: Center(child: Icon(Icons.settings)),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: widget.onClickBack,
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: buttonHitboxWidth,
                      height: buttonHitboxHeight,
                      child: const Icon(Icons.arrow_left, size: buttonSize),
                    ),
                  ),
                  SizedBox(
                    width: circleSize,
                    height: circleSize,
                  ),
                  SizedBox(width: buttonHitboxWidth),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: widget.onClickForward,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: buttonHitboxHeight,
                  height: buttonHitboxHeight,
                  child: const Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 40),
                      child: Icon(
                        Icons.arrow_drop_down,
                        size: buttonSize,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
