import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../screens/market/model/market_item_model.dart';
import '../../../../../../../screens/market/provider/market_items_pod.dart';
import '../../../../../../components/asset_icon.dart';
import '../../../../../../helpers/format_currency_amount.dart';
import '../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../wallet/helper/market_item_from.dart';
import '../../../../../wallet/view/empty_wallet.dart';
import '../../../../../wallet/view/wallet.dart';

class BalanceAssetItem extends HookWidget {
  const BalanceAssetItem({
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
    final baseCurrency = useProvider(baseCurrencyPod);

    return InkWell(
      onTap: () => _navigateToWallet(context, marketItem),
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
                  formatCurrencyAmount(
                    prefix: baseCurrency.prefix,
                    value: marketItem.baseBalance,
                    accuracy: baseCurrency.accuracy,
                    symbol: baseCurrency.symbol,
                  ),
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                Text(
                  formatCurrencyAmount(
                    symbol: marketItem.id,
                    value: marketItem.assetBalance,
                    accuracy: marketItem.accuracy,
                    prefix: marketItem.prefixSymbol,
                  ),
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
