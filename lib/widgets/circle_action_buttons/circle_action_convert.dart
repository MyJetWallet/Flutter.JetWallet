import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class CircleActionConvert extends StatelessWidget {
  const CircleActionConvert({
    super.key,
    required this.onTap,
    this.isDisabled = false,
  });

  final Function() onTap;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    return SActionButton(
      icon: Assets.svg.medium.transfer.simpleSvg(
        color: SColorsLight().white,
      ),
      state: isDisabled ? ActionButtonState.disabled : ActionButtonState.defaylt,
      onTap: onTap,
      lable: intl.convert_convert,
    );
  }
}
