import 'package:anchor/widgets/button.dart';
import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class SettingsPage extends StatefulWidget {
  final void Function()? onClickBack;
  final void Function()? onClickForward;

  const SettingsPage({
    super.key,
    this.onClickBack,
    this.onClickForward,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
                      onPressed: () {},
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(spacing),
                    child: CustomButton(
                      text: "Change name",
                      icon: HeroIcons.pencil,
                      onPressed: () {
                        TextEditingController controller =
                            TextEditingController(text: "Jacob");

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
