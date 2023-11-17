import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

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
    final colors = sKit.colors;

    return Expanded(
      child: Column(
        children: [
          SimpleCircleButton(
            defaultIcon: SFreezeIcon(
              color: colors.white,
            ),
            pressedIcon: SFreezeIcon(
              color: colors.white.withOpacity(0.7),
            ),
            onTap: onTap,
            isDisabled: isDisabled,
            name: isFrozen ? intl.simple_card_unfreeze : intl.simple_card_freeze,
          ),
        ],
      ),
    );
  }
}
