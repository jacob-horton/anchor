import 'package:anchor/models/background.dart';
import 'package:anchor/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndPage extends StatefulWidget {
  const EndPage({super.key});

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  String username = 'User';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    // TODO: reload when popping to this state
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username") ?? 'User';
    });
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
              child: Text(
                username,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                print('tapped');
                final value = context.read<BackgroundModel>();
                print(value);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        ChangeNotifierProvider<BackgroundModel>.value(
                      value: value,
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
