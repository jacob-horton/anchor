import 'package:anchor/pages/settings.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

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
    return PageTemplate(
      titleBar: Row(
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
              MaterialPageRoute(builder: (context) => const SettingsPage()),
            ),
            child: const SizedBox(
              width: 70,
              height: 70,
              child: Center(child: HeroIcon(HeroIcons.cog6Tooth)),
            ),
          ),
        ],
      ),
      onNavigateDown: widget.onClickForward,
      onNavigateLeft: widget.onClickBack,
      body: Container(),
    );
  }
}
