import 'package:anchor/models/background.dart';
import 'package:anchor/models/hide_foreground.dart';
import 'package:anchor/models/username.dart';
import 'package:anchor/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:provider/provider.dart';

class EndPage extends StatefulWidget {
  const EndPage({super.key});

  @override
  State<EndPage> createState() => _EndPageState();
}

class _EndPageState extends State<EndPage> {
  final TextEditingController _usernameController = TextEditingController();
  UsernameModel? _usernameModel;
  void Function()? _usernameListener;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_usernameModel == null) {
      // Setup listener to update controller when username changes
      _usernameModel = Provider.of<UsernameModel>(context);
      _usernameListener = () {
        _usernameController.text = _usernameModel!.username;
      };

      _usernameModel!.addListener(_usernameListener!);
    }

    return Consumer<HideForegroundModel>(
      builder: (context, hideForegroundModel, child) => GestureDetector(
        onTap: () => setState(() => hideForegroundModel.toggleHideForeground()),
        behavior: HitTestBehavior.opaque,
        child: hideForegroundModel.hideForeground
            ? Container()
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: SizedBox(
                          width: 200,
                          child: TextField(
                            controller: _usernameController,
                            onChanged: (text) =>
                                _usernameModel!.username = text,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 2),
                                  blurRadius: 25,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          final background = context.read<BackgroundModel>();
                          final username = context.read<UsernameModel>();

                          FocusScope.of(context).focusedChild?.unfocus();

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
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 15,
                                spreadRadius: -20,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: HeroIcon(
                              HeroIcons.cog6Tooth,
                              style: HeroIconStyle.solid,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    if (_usernameListener != null) {
      _usernameModel?.removeListener(_usernameListener!);
    }

    super.dispose();
  }
}
