import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

class LoaderBackground extends StatelessWidget {
  const LoaderBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SColorsLight().black.withOpacity(0.5),
    );
  }
}
