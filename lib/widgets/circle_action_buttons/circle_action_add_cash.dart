import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

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
    final colors = sKit.colors;

    return Expanded(
      child: Column(
        children: [
          SimpleCircleButton(
            defaultIcon: SCasheIcon(
              color: colors.white,
            ),
            pressedIcon: SCasheIcon(
              color: colors.white.withOpacity(0.7),
            ),
            onTap: onTap,
            isDisabled: isDisabled,
          ),
          const SpaceH6(),
          Text(
            intl.balanceActionButtons_add_cash,
            style: sBodyText2Style.copyWith(
              fontWeight: FontWeight.w600,
              color: isDisabled ? colors.grey2 : null,
            ),
          ),
        ],
      ),
    );
  }
}
