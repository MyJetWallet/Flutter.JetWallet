import 'package:flutter/material.dart';

import '../../../../../../shared/components/spacers.dart';
import '../../../../market/model/market_item_model.dart';
import 'components/balance_action_buttons.dart';
import 'components/balance_asset_item.dart';
import 'components/balance_frame.dart';

class BalanceBlock extends StatelessWidget {
  const BalanceBlock({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return BalanceFrame(
      child: Column(
        children: [
          BalanceAssetItem(
            marketItem: marketItem,
          ),
          const SpaceH8(),
          BalanceActionButtons(
            marketItem: marketItem,
          ),
        ],
      ),
    );
  }
}
