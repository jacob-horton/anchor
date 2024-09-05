import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyIsFirstLoad = 'is-first-load';

showWelcomeIfFirstLoad(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstLoaded = prefs.getBool(_keyIsFirstLoad) ?? true;

  if (!context.mounted) {
    return;
  }

  if (isFirstLoaded) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const WelcomeMessage(),
    );
  }
}

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Welcome",
        style: Theme.of(context).textTheme.titleSmall,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Hi, I hope you find the app useful. Anchor is an app that was designed to help neurodivergent people who are feeling anxious and/or nervous. The songs were made with the specific intention of being an 'anchor' for someone who is distressed. They feature repetitive melodies, rhythms and soft sounds to try and create a soothing and consistent environment. The app wont be for everyone, but I hope that it helps you in moments when things are overwhelming.",
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14.0),
          ),
          const SizedBox(height: 10.0),
          Text(
            "Please swipe to the left and then swipe up to see the list of songs.",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontWeight: FontWeight.w700, fontSize: 14.0),
          )
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Dismiss"),
          onPressed: () async {
            Navigator.of(context).pop();

            var prefs = await SharedPreferences.getInstance();
            prefs.setBool(_keyIsFirstLoad, false);
          },
        ),
      ],
    );
  }
}
