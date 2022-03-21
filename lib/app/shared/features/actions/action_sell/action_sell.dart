import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../currency_sell/view/currency_sell.dart';
import '../helper/action_bottom_sheet_header.dart';
import '../provider/action_buy_filtered_stpod.dart';

void showSellAction(BuildContext context) {
  final actionBuyFiltered = context.read(actionBuyFilteredStpod);
  Navigator.pop(context); // close BasicBottomSheet from Menu
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const ActionBottomSheetHeader(
      name: 'Choose asset to sell',
    ),
    horizontalPinnedPadding: 0.0,
    onDissmis: () => actionBuyFiltered.state = '',
    removePinnedPadding: true,
    children: [const _ActionSell()],
  );
}

class _ActionSell extends HookWidget {
  const _ActionSell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final currencies = useProvider(currenciesPod);

    final actionBuyFiltered = useProvider(actionBuyFilteredStpod);

    if (actionBuyFiltered.state.isNotEmpty) {
      final search = actionBuyFiltered.state.toLowerCase();

      currencies.removeWhere(
            (element) => !(element.description.toLowerCase()).contains(search),
      );
    }

    final assetWithBalance = <CurrencyModel>[];

    for (final currency in currencies) {
      if (currency.baseBalance != Decimal.zero) {
        assetWithBalance.add(currency);
      }
    }

    return Column(
      children: [
        for (final currency in assetWithBalance) ...[
          if (currency.isAssetBalanceNotEmpty)
            SWalletItem(
              decline: currency.dayPercentChange.isNegative,
              icon: SNetworkSvg24(
                url: currency.iconUrl,
              ),
              primaryText: currency.description,
              amount: currency.volumeBaseBalance(baseCurrency),
              secondaryText: currency.volumeAssetBalance,
              removeDivider: currency == assetWithBalance.last,
              onTap: () {
                sAnalytics.buySellView(
                  ScreenSource.quickActions,
                  currency.description,
                );

                actionBuyFiltered.state = '';

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
