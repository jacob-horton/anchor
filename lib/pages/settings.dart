import 'package:anchor/models/background.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/widgets/button.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  late final SharedPreferences prefs;
  final void Function()? onClickBack;
  final void Function()? onClickForward;

  SettingsPage({
    super.key,
    this.onClickBack,
    this.onClickForward,
  }) {
    _loadPrefs();
  }

  void _loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    const spacing = 10.0;
    BackgroundModel background = Provider.of<BackgroundModel>(context);
    UsernameModel username = Provider.of<UsernameModel>(context);

    return PageTemplate(
      titleBar: const Text("Settings"),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              height: 80,
              child: Row(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: HeroIcon(HeroIcons.arrowLeftCircle),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text("Settings",
                      style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(spacing),
                    child: CustomButton(
                      text: "Choose background",
                      icon: HeroIcons.photo,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return BackgroundButton(
                              initialBackground: background.filename,
                              onSave: (f) => background.updateFilename(f),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(spacing),
                    child: CustomButton(
                      text: "Change name",
                      icon: HeroIcons.pencil,
                      onPressed: () {
                        TextEditingController controller =
                            TextEditingController(text: username.username);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Change Name'),
                              content: TextField(
                                controller: controller,
                                decoration: const InputDecoration(
                                  hintText: "Your name",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.grey),
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Save'),
                                  onPressed: () {
                                    // TODO: success toast?
                                    username.username = controller.text;
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BackgroundButton extends StatefulWidget {
  final String initialBackground;
  final void Function(String filename) onSave;

  const BackgroundButton({
    super.key,
    required this.initialBackground,
    required this.onSave,
  });

  @override
  State<BackgroundButton> createState() => _BackgroundButtonState();
}

class _BackgroundButtonState extends State<BackgroundButton> {
  static const backgrounds = [
    'northern-lights.jpg',
    'sea.jpg',
    'stars.jpg',
    'sunset.jpg',
  ];

  late String selectedBackground;

  @override
  void initState() {
    super.initState();
    selectedBackground = widget.initialBackground;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Choose Background'),
      content: SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: GridView.count(
          crossAxisCount: 2,
          children: backgrounds
              .map(
                (b) => GestureDetector(
                  onTap: () {
                    setState(() => selectedBackground = b);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 1,
                          child: Image(
                            image: AssetImage('images/$b'),
                            // width: 36,
                            // height: 36,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (selectedBackground == b)
                          Container(
                            color: Colors.black38,
                            child: const Center(
                              child: HeroIcon(
                                HeroIcons.check,
                                color: Colors.white,
                                style: HeroIconStyle.micro,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            widget.onSave(selectedBackground);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
