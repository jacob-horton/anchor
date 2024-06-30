import 'package:anchor/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class EndPage extends StatefulWidget {
  const EndPage({super.key});

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
      ],
    );
  }
}
