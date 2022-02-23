import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../currency_sell/view/currency_sell.dart';

void showSellAction(BuildContext context) {
  Navigator.pop(context); // close BasicBottomSheet from Menu
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const SBottomSheetHeader(
      name: 'Choose asset to sell',
    ),
    children: [const _ActionSell()],
  );
}

class _ActionSell extends HookWidget {
  const _ActionSell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final currencies = useProvider(currenciesPod);

    return Column(
      children: [
        for (final currency in currencies) ...[
          if (currency.isAssetBalanceNotEmpty)
            SWalletItem(
              decline: currency.dayPercentChange.isNegative,
              icon: SNetworkSvg24(
                url: currency.iconUrl,
              ),
              primaryText: currency.description,
              amount: currency.volumeBaseBalance(baseCurrency),
              secondaryText: currency.volumeAssetBalance,
              onTap: () {
                sAnalytics.buySellView(
                  ScreenSource.quickActions,
                  currency.description,
                );

                navigatorPushReplacement(
                  context,
                  CurrencySell(
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
