import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

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
    final colors = sKit.colors;

    return Expanded(
      child: Column(
        children: [
          SimpleCircleButton(
            defaultIcon: SArrowDownIcon(
              color: colors.white,
            ),
            pressedIcon: SArrowDownIcon(
              color: colors.white.withOpacity(0.7),
            ),
            onTap: onTap,
            isDisabled: isDisabled,
          ),
          const SpaceH6(),
          Text(
            intl.balanceActionButtons_receive,
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
