import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';

enum CircleButtonType { addCash, withdraw, exchange, settings }

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
          return Assets.svg.medium.addCash.simpleSvg(
            color: sKit.colors.white,
          );
        case CircleButtonType.withdraw:
          return Assets.svg.medium.withdrawal.simpleSvg(
            color: sKit.colors.white,
          );
        case CircleButtonType.exchange:
          return Assets.svg.medium.transfer.simpleSvg(
            color: sKit.colors.white,
          );
        case CircleButtonType.settings:
          return Assets.svg.medium.settings.simpleSvg(
            color: sKit.colors.white,
          );
        default:
          return const SizedBox.shrink();
      }
    }

    Widget getPressedIcon() {
      switch (type) {
        case CircleButtonType.addCash:
          return Assets.svg.medium.addCash.simpleSvg(
            color: sKit.colors.white,
          );
        case CircleButtonType.withdraw:
          return Assets.svg.medium.withdrawal.simpleSvg(
            color: sKit.colors.white,
          );
        case CircleButtonType.exchange:
          return Assets.svg.medium.transfer.simpleSvg(
            color: sKit.colors.white,
          );
        case CircleButtonType.settings:
          return Assets.svg.medium.settings.simpleSvg(
            color: sKit.colors.white,
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
