import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CircleActionFreeze extends StatelessWidget {
  const CircleActionFreeze({
    super.key,
    required this.onTap,
    required this.isFrozen,
    this.isDisabled = false,
  });

  final Function() onTap;
  final bool isDisabled;
  final bool isFrozen;

  @override
  Widget build(BuildContext context) {
    return SActionButton(
      onTap: onTap,
      lable: isFrozen ? intl.simple_card_unfreeze : intl.simple_card_freeze,
      icon: Assets.svg.medium.arrowUp.simpleSvg(
        color: SColorsLight().white,
      ),
      state: isDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
    );
  }
}
