import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CircleActionAddCash extends StatelessWidget {
  const CircleActionAddCash({
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
      icon: Assets.svg.medium.cash.simpleSvg(
        color: colors.white,
      ),
      onTap: onTap,
      state: isDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
      lable: intl.balanceActionButtons_add_cash,
    );
  }
}
