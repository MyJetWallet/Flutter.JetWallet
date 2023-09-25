import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/actions/helpers/show_currency_search.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/my_wallets/widgets/wallet_search_item.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';

void showAddWalletBottomSheet(BuildContext context) {
  final showSearch = showSellCurrencySearch(context);
  final a = ActionSearchStore();
  a.init();
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    then: (value) {},
    pinned: ActionBottomSheetHeader(
      name: 'Add wallet',
      showSearch: showSearch,
      onChanged: (String value) {
        getIt.get<ActionSearchStore>().search(value);
      },
      horizontalDividerPadding: 24,
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [const _ActionSell()],
  );
}

class _ActionSell extends StatelessObserverWidget {
  const _ActionSell();

  @override
  Widget build(BuildContext context) {
    final state = getIt.get<ActionSearchStore>();

    final assetWithBalance = <CurrencyModel>[];

    for (final currency in state.filteredCurrencies) {
      if (currency.baseBalance != Decimal.zero) {
        assetWithBalance.add(currency);
      }
    }

    return Column(
      children: [
        const SpaceH16(),
        for (final currency in assetWithBalance) ...[
          if (currency.isAssetBalanceNotEmpty)
            WalletSearchItem(
              icon: SNetworkSvg24(
                url: currency.iconUrl,
              ),
              description: currency.description,
              symbol: currency.symbol,
              onTap: () {
                print('object');
              },
            ),
        ],
      ],
    );
  }
}
