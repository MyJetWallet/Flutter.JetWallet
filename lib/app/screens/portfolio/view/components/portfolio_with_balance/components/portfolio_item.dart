import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../shared/components/asset_icon.dart';
import '../../../../../../shared/features/market_details/helper/currency_from.dart';
import '../../../../../../shared/features/wallet/provider/wallet_hidden_stpod.dart';
import '../../../../../../shared/features/wallet/view/empty_wallet.dart';
import '../../../../../../shared/features/wallet/view/wallet.dart';
import '../../../../../../shared/helpers/format_currency_amount.dart';
import '../../../../../../shared/models/currency_model.dart';
import '../../../../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../../../../shared/providers/currencies_pod/currencies_pod.dart';
import 'portfolio_small_text.dart';

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
    final baseCurrency = useProvider(baseCurrencyPod);
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
                PortfolioSmallText(
                  text: '${formatCurrencyAmount(
                    value: currency.currentPrice,
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                    prefix: baseCurrency.prefix,
                  )} '
                      '/ ${currency.dayPercentChange}%',
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  hidden.state
                      ? '???'
                      : formatCurrencyAmount(
                          value: currency.baseBalance,
                          symbol: baseCurrency.symbol,
                          accuracy: baseCurrency.accuracy,
                          prefix: baseCurrency.prefix,
                        ),
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
                PortfolioSmallText(
                  text: _assetBalance(currency, hidden.state),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _assetBalance(CurrencyModel currency, bool hidden) {
    if (currency.assetBalance == 0.0) {
      return '';
    } else if (hidden) {
      return '???';
    } else {
      return '${currency.assetBalance} ${currency.symbol}';
    }
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
