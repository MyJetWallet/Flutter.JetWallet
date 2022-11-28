import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/utils/constants.dart';

class LoaderSpinner extends StatelessWidget {
  const LoaderSpinner({
    Key? key,
    this.size = 24,
  }) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const RiveAnimation.asset(loadingAnimationAsset),
    );
  }
}
