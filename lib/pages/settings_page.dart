import 'package:anchor/models/background.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/widgets/background_selector.dart';
import 'package:anchor/widgets/button.dart';
import 'package:anchor/widgets/name_changer.dart';
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
    return PageTemplate(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderTitleBar(context),
          Expanded(child: Center(child: _renderButtons(context))),
        ],
      ),
    );
  }

  Widget _renderButtons(BuildContext context) {
    const spacing = 10.0;
    BackgroundModel background = Provider.of<BackgroundModel>(context);
    UsernameModel username = Provider.of<UsernameModel>(context);

    return Column(
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
                  return BackgroundSelector(
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
              TextEditingController controller = TextEditingController(
                text: username.username,
              );

              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return NameChanger(
                    controller: controller,
                    username: username,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _renderTitleBar(BuildContext context) {
    return Padding(
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
    );
  }
}
