import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../../../../../../simple_kit.dart';

class LoaderSpinner extends StatelessWidget {
  const LoaderSpinner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 24.0,
      height: 24.0,
      child: RiveAnimation.asset(loadingAnimationAsset),
    );
  }
}
