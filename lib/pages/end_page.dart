import 'package:anchor/models/background.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class EndPage extends StatefulWidget {
  const EndPage({super.key});

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  @override
  void initState() {
    super.initState();
  }

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
              child: Consumer<UsernameModel>(
                builder: (context, username, _) => Text(
                  username.username,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                final background = context.read<BackgroundModel>();
                final username = context.read<UsernameModel>();

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MultiProvider(
                      providers: [
                        ChangeNotifierProvider<BackgroundModel>.value(
                          value: background,
                        ),
                        ChangeNotifierProvider<UsernameModel>.value(
                          value: username,
                        ),
                      ],
                      child: SettingsPage(),
                    ),
                  ),
                );
              },
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
