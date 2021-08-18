import 'package:flutter/material.dart';

import '../../../../../../../shared/components/buttons/app_buton_white.dart';
import '../../../../../../../shared/components/spacers.dart';
import '../../../../../market/model/market_item_model.dart';

class BalanceActionButtons extends StatelessWidget {
  const BalanceActionButtons({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButtonWhite(
            name: 'Buy',
            onTap: () {},
          ),
        ),
        if (!marketItem.isBalanceEmpty) ...[
          const SpaceW16(),
          Expanded(
            child: AppButtonWhite(
              name: 'Sell',
              onTap: () {},
            ),
          ),
        ]
      ],
    );
  }
}
