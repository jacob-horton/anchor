import 'package:anchor/widgets/page_template.dart';
import 'package:flutter/material.dart';

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
    return PageTemplate(
      titleBar: Text(
        "Settings",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      body: const Placeholder(),
    );
  }
}
