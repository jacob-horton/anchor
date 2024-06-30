import 'package:flutter/material.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    final albumSize = MediaQuery.of(context).size.width / 2;

    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: albumSize,
            height: albumSize,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(albumSize / 5),
              border: Border.all(
                color: Colors.white54,
                width: 6,
                strokeAlign: BorderSide.strokeAlignOutside,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 35),
            child: Icon(Icons.pause, color: Colors.white, size: 48.0),
          ),
        ],
      ),
    );
  }
}
