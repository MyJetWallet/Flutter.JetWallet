import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CircleActionBuy extends StatelessWidget {
  const CircleActionBuy({
    super.key,
    required this.onTap,
    this.isDisabled = false,
  });

  final Function() onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SActionButton(
      icon: Assets.svg.medium.add.simpleSvg(
        color: colors.white,
      ),
      state: isDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
      onTap: onTap,
      lable: intl.balanceActionButtons_buy,
    );
  }
}
