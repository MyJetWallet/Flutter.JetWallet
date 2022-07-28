import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../constants.dart';

class WaitingAnimation extends StatelessWidget {
  const WaitingAnimation({
    Key? key,
    required this.widgetSize,
  }) : super(key: key);

  final SWidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widgetSize == SWidgetSize.small ? 160 : 320,
      height: widgetSize == SWidgetSize.small ? 160 : 320,
      child: Stack(
        children: const [
          RiveAnimation.asset(
            confirmActionAnimationAsset,
          ),
          Positioned.fill(
            child: Align(
              child: SizedBox(
                width: 80,
                height: 80,
                child: RiveAnimation.asset(
                  loaderAnimationAsset,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
