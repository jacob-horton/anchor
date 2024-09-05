import 'package:flutter/material.dart';

class PlaceholderFavouritesPage extends StatelessWidget {
  const PlaceholderFavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Text(
            "Please add a favourite",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontSize: 28.0,
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
    );
  }
}
