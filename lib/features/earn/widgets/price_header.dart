import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

class SPriceHeader extends StatelessWidget {
  const SPriceHeader({
    required this.totalSum,
    required this.revenueSum,
    super.key,
  });

  final String totalSum;
  final String revenueSum;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            intl.rewards_total,
            style: STStyles.subtitle1.copyWith(
              color: colors.black,
            ),
          ),
          Text(
            totalSum,
            style: STStyles.header2.copyWith(
              color: colors.black,
            ),
          ),
          Text(
            '${intl.earn_revenue} $revenueSum',
            style: STStyles.body2Medium.copyWith(
              color: colors.grey1,
            ),
          ),
        ],
      ),
    );
  }
}
