import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class LoaderBackground extends StatelessWidget {
  const LoaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SColorsLight().black.withOpacity(0.5),
    );
  }
}
