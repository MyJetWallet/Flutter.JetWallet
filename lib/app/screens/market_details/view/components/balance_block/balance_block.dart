import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      backgroundColor: Colors.white,
      height: 178.h,
      child: Column(
        children: [
          BalanceAssetItem(
            assetId: marketItem.associateAsset,
          ),
          const SpaceH10(),
          BalanceActionButtons(
            marketItem: marketItem,
          ),
        ],
      ),
    );
  }
}
