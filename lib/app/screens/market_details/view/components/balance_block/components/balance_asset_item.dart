import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../shared/components/spacers.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/components/asset_icon.dart';
import '../../../../../market/model/market_item_model.dart';
import '../../../../../wallet/view/empty_wallet.dart';
import '../../../../../wallet/view/wallet.dart';

class BalanceAssetItem extends StatelessWidget {
  const BalanceAssetItem({
    Key? key,
    required this.marketItem,
  }) : super(key: key);

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToWallet(context),
      child: Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 14.w,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(16.r),
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
      ),
    );
  }

  void _navigateToWallet(BuildContext context) {
    if (marketItem.isBalanceEmpty) {
      navigatorPush(
        context,
        EmptyWallet(
          assetName: marketItem.name,
        ),
      );
    } else {
      navigatorPush(
        context,
        Wallet(
          marketItem: marketItem,
        ),
      );
    }
  }
}
