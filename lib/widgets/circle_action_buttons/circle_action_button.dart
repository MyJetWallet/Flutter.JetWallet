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
  });

  final String text;
  final CircleButtonType type;
  final Function() onTap;

  final bool isDisabled;

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

    return SizedBox(
      height: 68,
      width: 68,
      child: Column(
        children: [
          SimpleCircleButton(
            height: 40,
            defaultIcon: getIcon(),
            pressedIcon: getPressedIcon(),
            backgroundColor: isDisabled ? sKit.colors.grey4 : sKit.colors.black,
            onTap: isDisabled ? null : onTap,
          ),
          const SpaceH10(),
          Text(
            text,
            style: sCaptionTextStyle.copyWith(
              color: isDisabled ? sKit.colors.grey2 : sKit.colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}