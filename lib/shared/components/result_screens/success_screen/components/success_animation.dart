import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../../constants.dart';

class SuccessAnimation extends StatelessWidget {
  const SuccessAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 320.0,
      height: 320.0,
      child: RiveAnimation.asset(
        successAnimationAsset,
      ),
    );
  }
}
