import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';

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
    final colors = sKit.colors;

    return InkWell(
      highlightColor: SColorsLight().grey5,
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
              style: sSubtitle2Style.copyWith(
                color: colors.black,
                height: 1,
              ),
            ),
            const Spacer(),
            Baseline(
              baseline: 14.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                symbol,
                style: sSubtitle3Style.copyWith(
                  color: colors.grey1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
