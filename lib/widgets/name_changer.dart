import 'package:anchor/models/username.dart';
import 'package:flutter/material.dart';

class NameChanger extends StatelessWidget {
  const NameChanger({
    super.key,
    required this.controller,
    required this.username,
  });

  final TextEditingController controller;
  final UsernameModel username;

  @override
  Widget build(BuildContext context) {
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
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            username.username = controller.text;
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
