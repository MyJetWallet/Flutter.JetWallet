import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../helpers/format_currency_amount.dart';
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
    final currencies = context.read(currenciesPod);

    return Column(
      children: [
        for (final currency in currencies) ...[
          SMarketItem(
            icon: SNetworkSvg24(
              url: currency.iconUrl,
            ),
            name: currency.description,
            price: formatCurrencyAmount(
              prefix: baseCurrency.prefix,
              value: baseCurrency.symbol == currency.symbol
                  ? 1
                  : currency.currentPrice,
              symbol: baseCurrency.symbol,
              accuracy: baseCurrency.accuracy,
            ),
            ticker: currency.symbol,
            last: currency == currencies.last,
            percent: currency.dayPercentChange,
            onTap: () {
              navigatorPushReplacement(
                context,
                CurrencyBuy(
                  currency: currency,
                ),
              );
            },
          ),
        ]
      ],
    );
  }
}
