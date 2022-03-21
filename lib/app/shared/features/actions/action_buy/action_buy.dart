import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../currency_buy/view/curency_buy.dart';
import '../helper/action_bottom_sheet_header.dart';
import '../provider/action_buy_filtered_stpod.dart';

void showBuyAction(BuildContext context) {
  final actionBuyFiltered = context.read(actionBuyFilteredStpod);
  Navigator.pop(context); // close BasicBottomSheet from Menu
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    onDissmis: () => actionBuyFiltered.state = '',
    pinned: const ActionBottomSheetHeader(
      name: 'Choose asset to buy',
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [const _ActionBuy()],
  );
}

class _ActionBuy extends HookWidget {
  const _ActionBuy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final currencies = useProvider(currenciesPod);
    final actionBuyFiltered = useProvider(actionBuyFilteredStpod);

    final assetWithBalance = <CurrencyModel>[];
    final assetWithOutBalance = <CurrencyModel>[];

    for (final currency in currencies) {
      if (currency.baseBalance != Decimal.zero) {
        assetWithBalance.add(currency);
      } else {
        assetWithOutBalance.add(currency);
      }
    }

    if (actionBuyFiltered.state.isNotEmpty) {
      final search = actionBuyFiltered.state.toLowerCase();

      currencies.removeWhere(
        (element) =>
            !(element.description.toLowerCase()).contains(search) &&
            !(element.symbol.toLowerCase()).contains(search),
      );
    }

    return Column(
      children: [
        for (final currency in currencies) ...[
          if (currency.supportsAtLeastOneBuyMethod)
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

                actionBuyFiltered.state = '';

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
