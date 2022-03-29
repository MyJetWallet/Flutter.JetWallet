import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../constants.dart';

class SuccessAnimation extends StatelessWidget {
  const SuccessAnimation({
    Key? key,
    required this.widgetSize,
  }) : super(key: key);

  final SWidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widgetSize == SWidgetSize.small ? 160 : 320,
      height: widgetSize == SWidgetSize.small ? 160 : 320,
      child: const RiveAnimation.asset(
        successAnimationAsset,
      ),
    );
  }
}
