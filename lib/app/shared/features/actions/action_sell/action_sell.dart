import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../models/currency_model.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../currency_sell/view/currency_sell.dart';
import '../helpers/show_currency_search.dart';
import '../shared/components/action_bottom_sheet_header.dart';
import '../shared/notifier/action_search_notipod.dart';

void showSellAction(BuildContext context) {
  final intl = context.read(intlPod);
  final showSearch = showSellCurrencySearch(context);
  Navigator.pop(context); // close BasicBottomSheet from Menu
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    then: (value) {
      sAnalytics.sellChooseAssetClose();
    },
    pinned: ActionBottomSheetHeader(
      name: intl.actionSell_bottomSheetHeaderName,
      showSearch: showSearch,
      onChanged: (String value) {
        context.read(actionSearchNotipod.notifier).search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [const _ActionSell()],
  );

  sAnalytics.sellSheetView();
}

class _ActionSell extends HookWidget {
  const _ActionSell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = useProvider(baseCurrencyPod);
    final state = useProvider(actionSearchNotipod);

    final assetWithBalance = <CurrencyModel>[];

    for (final currency in state.filteredCurrencies) {
      if (currency.baseBalance != Decimal.zero) {
        assetWithBalance.add(currency);
      }
    }

    sAnalytics.sellChooseAsset();

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
                sAnalytics.sellView(
                  Source.quickActions,
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
