import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/wallet_search_item.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';

void showAddWalletBottomSheet(BuildContext context, MyWalletsSrore store) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    then: (value) {},
    expanded: true,
    pinned: ActionBottomSheetHeader(
      name: intl.my_wallets_add_wallet,
      showSearch: store.currenciesForSearch.length >= 7,
      onChanged: (String value) {
        store.onSearch(value);
      },
      horizontalDividerPadding: 24,
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [_AssetsList(store)],
  );
}

class _AssetsList extends StatelessObserverWidget {
  const _AssetsList(this.store);

  final MyWalletsSrore store;

  @override
  Widget build(BuildContext context) {
    final currencies = store.currenciesForSearch;

    return Column(
      children: [
        const SpaceH16(),
        for (final currency in currencies)
          WalletSearchItem(
            icon: SNetworkSvg24(
              url: currency.iconUrl,
            ),
            description: currency.description,
            symbol: currency.symbol,
            onTap: () {
              store.onChooseAsetFromSearch(currency);
              sRouter.pop();
            },
          ),
      ],
    );
  }
}
