import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CircleActionReceive extends StatelessWidget {
  const CircleActionReceive({
    super.key,
    required this.onTap,
    this.isDisabled = false,
  });

  final Function() onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SActionButton(
      onTap: onTap,
      lable: intl.balanceActionButtons_receive,
      icon: Assets.svg.medium.arrowDown.simpleSvg(
        color: SColorsLight().white,
      ),
      state: isDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
    );
  }
}
