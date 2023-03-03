import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/helpers/show_currency_search.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

void showSellAction(BuildContext context) {
  final showSearch = showSellCurrencySearch(context);
  Navigator.pop(context); // close BasicBottomSheet from Menu
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    then: (value) {},
    pinned: ActionBottomSheetHeader(
      name: intl.actionSell_bottomSheetHeaderName,
      showSearch: showSearch,
      onChanged: (String value) {
        getIt.get<ActionSearchStore>().search(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [const _ActionSell()],
  );
}

class _ActionSell extends StatelessObserverWidget {
  const _ActionSell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = getIt.get<ActionSearchStore>();

    final assetWithBalance = <CurrencyModel>[];

    for (final currency in state.filteredCurrencies) {
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
                sRouter.navigate(
                  CurrencySellRouter(currency: currency),
                );
              },
            ),
        ],
      ],
    );
  }
}
