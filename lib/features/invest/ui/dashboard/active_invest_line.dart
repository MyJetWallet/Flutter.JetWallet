import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';

import '../../../../core/l10n/i10n.dart';

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
    final colors = SColorsLight();

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
                  color: colors.gray10,
                ),
              ),
              const SpaceW4(),
              Text(
                amount.toFormatCount(accuracy: 2, symbol: 'USDT'),
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
                color: colors.gray10,
              ),
            ),
            Text(
              profit.toFormatCount(accuracy: 2),
              style: STStyles.body2InvestB.copyWith(
                color: profit == Decimal.zero
                    ? SColorsLight().gray6
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
