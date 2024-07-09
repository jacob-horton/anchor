import 'package:anchor/widgets/button.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
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
                            const backgrounds = [
                              'architecture.jpg',
                              'beach-1.jpg',
                              'beach-2.jpg',
                              'beach-3.jpg',
                              'forest-1.jpg',
                              'forest-2.jpg',
                              'lake.jpg',
                              'nature.jpg',
                            ];

                            List<Widget> bgWidgets = backgrounds
                                .map(
                                  (b) => GestureDetector(
                                    onTap: () {
                                      // TODO: set selected, only save to prefs when hitting "save"
                                      prefs.setString(
                                        'background',
                                        'images/$b',
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Image(
                                        image: AssetImage('images/$b'),
                                        width: 36,
                                        height: 36,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                                .toList();

                            return AlertDialog(
                              title: const Text('Choose Background'),
                              content: SizedBox(
                                height: 250,
                                width: MediaQuery.of(context).size.width,
                                child: GridView.count(
                                  crossAxisCount: 3,
                                  children: bgWidgets,
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
                                    // TODO: save
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
                  Padding(
                    padding: const EdgeInsets.all(spacing),
                    child: CustomButton(
                      text: "Change name",
                      icon: HeroIcons.pencil,
                      onPressed: () {
                        TextEditingController controller =
                            TextEditingController(
                          text: prefs.getString('username'),
                        );

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
                                    prefs.setString(
                                        "username", controller.text);
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
                  Padding(
                    padding: const EdgeInsets.all(spacing),
                    child: CustomButton(
                      text: "Cancel Subscription",
                      icon: HeroIcons.xCircle,
                      onPressed: () {},
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
