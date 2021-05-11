import 'package:flutter/material.dart';

class MyTick extends StatelessWidget {
  const MyTick({required this.image, Key? key}) : super(key: key);

  final DecorationImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: image,
      ),
    );
  }
}
