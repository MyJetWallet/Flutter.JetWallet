import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/utils/constants.dart';

class LoaderSpinner extends StatelessWidget {
  const LoaderSpinner({
    super.key,
    this.size = 24,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Container(
        decoration: BoxDecoration(
          color: SColorsLight().grey5,
          shape: BoxShape.circle,
        ),
        child: const RiveAnimation.asset(
          loadingAnimationAsset,
        ),
      ),
    );
  }
}
