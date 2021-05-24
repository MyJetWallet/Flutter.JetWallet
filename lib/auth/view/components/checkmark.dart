import 'package:flutter/material.dart';

class Checkmark extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 200,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: ExactAssetImage(
            'assets/checkmark.png',
          ),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
