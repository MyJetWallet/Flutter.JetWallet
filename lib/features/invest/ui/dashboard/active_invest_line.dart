import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

import '../../../../core/l10n/i10n.dart';
import '../../../../utils/formatting/base/volume_format.dart';

class ActiveInvestLine extends StatelessObserverWidget {
  const ActiveInvestLine({
    super.key,
    required this.profit,
    required this.amount,
  });

  final Decimal profit;
  final Decimal amount;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: colors.green,
              ),
            ),
            const SpaceW2(),
            Text(
              intl.invest_active_invest,
              style: STStyles.body3InvestM.copyWith(
                color: colors.black,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Row(
            children: [
              Text(
                intl.invest_amount,
                style: STStyles.body3InvestM.copyWith(
                  color: colors.grey1,
                ),
              ),
              const SpaceW4(),
              Text(
                volumeFormat(decimal: amount, accuracy: 2, symbol: 'USDT'),
                style: STStyles.body3InvestSM.copyWith(
                  color: colors.black,
                ),
              ),
            ],
          ),
        ),
        Row(
          children: [
            Text(
              'PL ',
              style: STStyles.body3InvestM.copyWith(
                color: colors.grey1,
              ),
            ),
            Text(
              volumeFormat(
                decimal: profit,
                accuracy: 2,
                symbol: '',
              ),
              style: STStyles.body2InvestB.copyWith(
                color: profit == Decimal.zero
                    ? SColorsLight().grey3
                    : profit > Decimal.zero
                        ? SColorsLight().green
                        : SColorsLight().red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
