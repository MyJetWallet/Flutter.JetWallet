import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/screens/market/model/market_item_model.dart';
import 'package:jetwallet/app/screens/market/provider/market_items_pod.dart';
import 'package:jetwallet/app/shared/components/asset_icon.dart';
import 'package:jetwallet/app/shared/features/wallet/helper/market_item_from.dart';
import 'package:jetwallet/app/shared/features/wallet/provider/wallet_hidden_stpod.dart';
import 'package:jetwallet/app/shared/features/wallet/view/empty_wallet.dart';
import 'package:jetwallet/app/shared/features/wallet/view/wallet.dart';

import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../shared/helpers/navigator_push.dart';

class PortfolioItem extends HookWidget {
  const PortfolioItem({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final marketItem = marketItemFrom(
      useProvider(marketItemsPod),
      assetId,
    );
    final hidden = useProvider(walletHiddenStPod);

    return InkWell(
      onTap: () => _navigateToWallet(context, marketItem),
      child: Container(
        height: 64.h,
        padding: EdgeInsets.symmetric(
          vertical: 14.h,
          horizontal: 14.w,
        ),
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.all(
            Radius.circular(16.r),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AssetIcon(
              imageUrl: marketItem.iconUrl,
              width: 20.r,
              height: 20.r,
            ),
            const SpaceW8(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  marketItem.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  '\$${marketItem.lastPrice} / ${marketItem.dayPercentChange}%',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hidden.state ? '???' : '\$${marketItem.baseBalance}',
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  hidden.state
                      ? '???'
                      : '${marketItem.assetBalance} ${marketItem.id}',
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

  void _navigateToWallet(BuildContext context, MarketItemModel item) {
    if (item.isBalanceEmpty) {
      navigatorPush(
        context,
        EmptyWallet(
          assetName: item.name,
        ),
      );
    } else {
      navigatorPush(
        context,
        Wallet(
          marketItem: item,
        ),
      );
    }
  }
}
