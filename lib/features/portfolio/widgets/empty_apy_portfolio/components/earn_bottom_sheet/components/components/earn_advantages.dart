import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

import 'earn_advantage_item.dart';

class EarnAdvantages extends StatelessWidget {
  const EarnAdvantages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EarnAdvantageItem(
          text: intl.earnAdvantages_tradeAndWithdrawMoneyWithoutLimits,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: intl.earnAdvantages_noMinimumMonthlyBalance,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: '${intl.earnAdvantages_interestCalculatedEveryDay}\n'
              '${intl.earnAdvantages_paidOnTheFirstDayOfEveryMonth}',
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: '${intl.earnAdvantages_pricesMayVaryDependingOn}\n'
              '${intl.earnAdvantages_theMarketSituation}',
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }
}
