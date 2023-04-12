import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class CircleActionSend extends StatelessWidget {
  const CircleActionSend({
    super.key,
    required this.onTap,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Expanded(
      child: Column(
        children: [
          SimpleCircleButton(
            defaultIcon: SArrowUpIcon(
              color: colors.white,
            ),
            pressedIcon: SArrowUpIcon(
              color: colors.white.withOpacity(0.7),
            ),
            onTap: onTap,
          ),
          const SpaceH6(),
          Text(
            intl.balanceActionButtons_send,
            style: sBodyText2Style.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
