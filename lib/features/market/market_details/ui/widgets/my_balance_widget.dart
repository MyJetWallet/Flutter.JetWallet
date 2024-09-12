import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/features/wallet/helper/navigate_to_wallet.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class MyBalanceWidget extends StatelessWidget {
  const MyBalanceWidget({
    super.key,
    required this.marketItem,
  });

  final MarketItemModel marketItem;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;

    final currencies = sSignalRModules.currenciesList;
    final currency = currencyFrom(currencies, marketItem.symbol);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                intl.market_my_balance,
                style: STStyles.header5,
              ),
              Text(
                '${intl.market_total}: ${getIt<AppStore>().isBalanceHide ? '**** ${baseCurrency.symbol}' : marketItem.baseBalance.toFormatSum(
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                  )}',
                style: STStyles.subtitle1,
              ),
            ],
          ),
        ),
        SimpleTableAccount(
          assetIcon: Assets.svg.assets.crypto.defaultPlaceholder.simpleSvg(),
          label: intl.market_wallet,
          rightValue: getIt<AppStore>().isBalanceHide
              ? '**** ${baseCurrency.symbol}'
              : marketItem.baseBalance.toFormatSum(
                  symbol: baseCurrency.symbol,
                  accuracy: baseCurrency.accuracy,
                ),
          supplement: getIt<AppStore>().isBalanceHide
              ? '******* ${marketItem.symbol}'
              : marketItem.assetBalance.toFormatCount(
                  symbol: marketItem.symbol,
                  accuracy: marketItem.assetAccuracy,
                ),
          onTableAssetTap: () {
            sAnalytics.tapOnTheBalanceButtonOnMarketAssetScreen(
              asset: marketItem.symbol,
            );

            onMarketItemTap(
              context: context,
              currency: currency,
            );
          },
        ),
      ],
    );
  }

  void onMarketItemTap({
    required BuildContext context,
    required CurrencyModel currency,
  }) {
    navigateToWallet(context, currency);
  }
}
