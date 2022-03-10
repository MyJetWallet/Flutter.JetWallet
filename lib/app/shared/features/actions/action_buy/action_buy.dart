import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../currency_buy/view/curency_buy.dart';

void showBuyAction(BuildContext context) {
  Navigator.pop(context); // close BasicBottomSheet from Menu
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const SBottomSheetHeader(
      name: 'Choose asset to buy',
    ),
    children: [const _ActionBuy()],
  );
}

class _ActionBuy extends HookWidget {
  const _ActionBuy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final currencies = useProvider(currenciesPod);

    final currencyAssetCrypto = <CurrencyModel>[];
    final currencyFiat = <CurrencyModel>[];

    for (final currency in currencies) {
      if (currency.type == AssetType.crypto) {
        currencyAssetCrypto.add(currency);
      } else {
        currencyFiat.add(currency);
      }
    }

    return Column(
      children: [
        for (final currency in currencyAssetCrypto) ...[
          SMarketItem(
            icon: SNetworkSvg24(
              url: currency.iconUrl,
            ),
            name: currency.description,
            price: marketFormat(
              prefix: baseCurrency.prefix,
              decimal: baseCurrency.symbol == currency.symbol
                  ? Decimal.one
                  : currency.currentPrice,
              symbol: baseCurrency.symbol,
              accuracy: baseCurrency.accuracy,
            ),
            ticker: currency.symbol,
            last: currency == currencies.last,
            percent: currency.dayPercentChange,
            onTap: () {
              sAnalytics.buySellView(
                ScreenSource.quickActions,
                currency.description,
              );

              navigatorPushReplacement(
                context,
                CurrencyBuy(
                  currency: currency,
                ),
              );
            },
          ),
        ],
        const SDivider(),
        for (final currency in currencyFiat) ...[
            SMarketItem(
              icon: SNetworkSvg24(
                url: currency.iconUrl,
              ),
              name: currency.description,
              price: marketFormat(
                prefix: baseCurrency.prefix,
                decimal: baseCurrency.symbol == currency.symbol
                    ? Decimal.one
                    : currency.currentPrice,
                symbol: baseCurrency.symbol,
                accuracy: baseCurrency.accuracy,
              ),
              ticker: currency.symbol,
              last: currency == currencies.last,
              percent: currency.dayPercentChange,
              onTap: () {
                sAnalytics.buySellView(
                  ScreenSource.quickActions,
                  currency.description,
                );

                navigatorPushReplacement(
                  context,
                  CurrencyBuy(
                    currency: currency,
                  ),
                );
              },
            ),
        ],
      ],
    );
  }
}
