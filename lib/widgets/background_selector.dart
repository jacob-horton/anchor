import 'package:anchor/data/backgrounds.dart';
import 'package:anchor/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class BackgroundSelector extends StatefulWidget {
  final String initialBackground;
  final void Function(String filename, bool isAsset) onSave;

  const BackgroundSelector({
    super.key,
    required this.initialBackground,
    required this.onSave,
  });

  @override
  State<BackgroundSelector> createState() => _BackgroundSelectorState();
}

class _BackgroundSelectorState extends State<BackgroundSelector> {
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
