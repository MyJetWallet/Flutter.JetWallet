import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';

class WalletSearchItem extends StatelessWidget {
  const WalletSearchItem({
    super.key,
    required this.icon,
    required this.description,
    required this.symbol,
    required this.onTap,
  });

  final Widget icon;
  final String description;
  final String symbol;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return InkWell(
      highlightColor: colors.gray2,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            icon,
            const SpaceW12(),
            Text(
              description,
              style: STStyles.subtitle1.copyWith(
                height: 1,
              ),
            ),
            const Spacer(),
            Baseline(
              baseline: 14.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                symbol,
                style: STStyles.subtitle2.copyWith(
                  color: colors.gray10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
