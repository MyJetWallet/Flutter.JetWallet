import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CircleActionSend extends StatelessWidget {
  const CircleActionSend({
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
      lable: intl.balanceActionButtons_send,
      icon: Assets.svg.medium.arrowUp.simpleSvg(
        color: SColorsLight().white,
      ),
      state: isDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
    );
  }
}
