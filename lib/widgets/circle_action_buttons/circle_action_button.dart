import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

enum CircleButtonType { addCash, withdraw }

class CircleActionButton extends StatelessWidget {
  const CircleActionButton({
    super.key,
    required this.text,
    required this.type,
    required this.onTap,
    this.isDisabled = false,
    this.isExpanded = true,
  });

  final String text;
  final CircleButtonType type;
  final Function() onTap;

  final bool isDisabled;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    Widget getIcon() {
      switch (type) {
        case CircleButtonType.addCash:
          return SCasheIcon(
            color: sKit.colors.white,
          );
        case CircleButtonType.withdraw:
          return RotatedBox(
            quarterTurns: 2,
            child: SBackIcon(
              color: sKit.colors.white,
            ),
          );
        default:
          return const SizedBox.shrink();
      }
    }

    Widget getPressedIcon() {
      switch (type) {
        case CircleButtonType.addCash:
          return SCasheIcon(
            color: sKit.colors.white.withOpacity(0.7),
          );
        case CircleButtonType.withdraw:
          return RotatedBox(
            quarterTurns: 2,
            child: SBackIcon(
              color: sKit.colors.white.withOpacity(0.7),
            ),
          );
        default:
          return const SizedBox.shrink();
      }
    }

    return SimpleCircleButton(
      defaultIcon: getIcon(),
      pressedIcon: getPressedIcon(),
      backgroundColor: isDisabled ? sKit.colors.grey4 : sKit.colors.black,
      onTap: isDisabled ? null : onTap,
      isExpanded: isExpanded,
      name: text,
    );
  }
}
