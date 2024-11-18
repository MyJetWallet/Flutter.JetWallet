import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
          color: SColorsLight().gray2,
          shape: BoxShape.circle,
        ),
        child: RiveAnimation.asset(
          Assets.animations.loader,
        ),
      ),
    );
  }
}
