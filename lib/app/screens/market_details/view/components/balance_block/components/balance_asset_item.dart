import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/components/asset_icon.dart';
import '../../../../../market/model/market_item_model.dart';

class BalanceAssetItem extends StatelessWidget {
  const BalanceAssetItem({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 14.h,
        horizontal: 14.w,
      ),
      margin: EdgeInsets.symmetric(
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(5.r),
        ),
      ),
      child: Row(
        children: [
          AssetIcon(
            imageUrl: marketItem.iconUrl,
          ),
          const SpaceW8(),
          Text(
            '${marketItem.name} Wallet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade500,
            ),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${marketItem.baseBalance}',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
              Text(
                '${marketItem.assetBalance} ${marketItem.id}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
