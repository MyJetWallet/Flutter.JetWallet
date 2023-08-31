import 'package:flutter/material.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:rive/rive.dart';
import 'package:simple_kit/simple_kit.dart';

class WaitingAnimation extends StatelessWidget {
  const WaitingAnimation({
    super.key,
    required this.widgetSize,
  });

  final SWidgetSize widgetSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widgetSize == SWidgetSize.small ? 160 : 320,
      height: widgetSize == SWidgetSize.small ? 160 : 320,
      child: Stack(
        children: const [
          RiveAnimation.asset(
            processingAnimationAsset,
          ),
        ],
      ),
    );
  }
}
