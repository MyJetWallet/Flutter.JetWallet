import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/portfolio/widgets/empty_apy_portfolio/components/earn_bottom_sheet/components/components/earn_advantage_item.dart';
import 'package:simple_kit/simple_kit.dart';

class EarnPageAdvantages extends StatelessWidget {
  const EarnPageAdvantages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EarnAdvantageItem(
          text: intl.earn_advantage1,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: intl.earn_advantage2,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: intl.earn_advantage3,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        const SpaceH16(),
        EarnAdvantageItem(
          text: intl.earn_advantage4,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }
}
