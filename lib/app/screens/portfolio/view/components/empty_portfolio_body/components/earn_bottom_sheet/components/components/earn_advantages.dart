import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import 'earn_advantage_item.dart';

class EarnAdvantages extends StatelessWidget {
  const EarnAdvantages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        EarnAdvantageItem(
          text: 'Trade and Withdraw without any limits',
        ),
        SpaceH16(),
        EarnAdvantageItem(
          text: 'No minimum monthly balance',
        ),
        SpaceH16(),
        EarnAdvantageItem(
          text:
              'Interest calculated every day and\npaid on the first day'
                  ' of every month',
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        SpaceH16(),
        EarnAdvantageItem(
          text: 'Rates are subject to change based on\nthe market situation',
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }
}
