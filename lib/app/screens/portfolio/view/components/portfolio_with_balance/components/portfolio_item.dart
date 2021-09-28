import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/market_details/helper/currency_from.dart';
import 'package:jetwallet/app/shared/models/currency_model.dart';
import 'package:jetwallet/app/shared/providers/currencies_pod/currencies_pod.dart';

import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/components/asset_icon.dart';
import '../../../../../../shared/features/wallet/helper/market_item_from.dart';
import '../../../../../../shared/features/wallet/provider/wallet_hidden_stpod.dart';
import '../../../../../../shared/features/wallet/view/empty_wallet.dart';
import '../../../../../../shared/features/wallet/view/wallet.dart';
import '../../../../../market/model/market_item_model.dart';
import '../../../../../market/provider/market_items_pod.dart';

class PortfolioItem extends HookWidget {
  const PortfolioItem({
    Key? key,
    required this.assetId,
  }) : super(key: key);

  final String assetId;

  @override
  Widget build(BuildContext context) {
    final currency = currencyFrom(
      useProvider(currenciesPod),
      assetId,
    );
    final hidden = useProvider(walletHiddenStPod);

    return InkWell(
      onTap: () => _navigateToWallet(context, currency),
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
              imageUrl: currency.iconUrl,
              width: 20.r,
              height: 20.r,
            ),
            const SpaceW8(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currency.description,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade500,
                  ),
                ),
                Text(
                  '\$${currency.currentPrice} / ${currency.dayPercentChange}%',
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
                  hidden.state ? '???' : '\$${currency.baseBalance}',
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                Text(
                  _assetBalance(currency, hidden.state),
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

  String _assetBalance(CurrencyModel currency, bool hidden) {
    return currency.assetBalance == 0.0
        ? ''
        : hidden
            ? '???'
            : '${currency.assetBalance} ${currency.symbol}';
  }

  void _navigateToWallet(BuildContext context, CurrencyModel currency) {
    if (currency.isAssetBalanceEmpty) {
      navigatorPush(
        context,
        EmptyWallet(
          assetName: currency.description,
        ),
      );
    } else {
      navigatorPush(
        context,
        Wallet(
          assetId: currency.assetId,
        ),
      );
    }
  }
}
