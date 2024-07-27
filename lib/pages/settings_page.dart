import 'dart:io';

import 'package:anchor/models/background.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/widgets/button.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as p;

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
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const HeroIcon(
                          HeroIcons.arrowLeftCircle,
                          style: HeroIconStyle.solid,
                          size: 28.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Text(
                    "Settings",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 2),
                          blurRadius: 25,
                        )
                      ],
                    ),
                  ),
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
                              initialBackground: background.path,
                              onSave: (f, isAsset) => isAsset
                                  ? background.setToAsset(f)
                                  : background.setToCustomImage(f),
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
                              title: Text(
                                'Change Name',
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              content: TextField(
                                controller: controller,
                                style: Theme.of(context).textTheme.bodySmall,
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
  final void Function(String filename, bool isAsset) onSave;

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
    'images/northern-lights.jpg',
    'images/sea.jpg',
    'images/stars.jpg',
    'images/sunset.jpg',
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
      title: Text(
        'Choose Background',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
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
                                image: AssetImage(b),
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
          const SizedBox(height: 20.0),
          CustomButton(
            text: "Select from library",
            icon: HeroIcons.photo,
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);

              if (image == null) {
                return;
              }

              final String destDir =
                  (await getApplicationDocumentsDirectory()).path;

              final ext = p.extension(image.path);
              final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
              final path = '$destDir/custom-background-$timestamp$ext';
              await image.saveTo(path);

              setState(() => selectedBackground = path);
            },
          ),
        ],
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
            widget.onSave(
              selectedBackground,
              backgrounds.contains(selectedBackground),
            );
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
