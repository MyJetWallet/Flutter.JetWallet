import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/wallet_search_item.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

void showAddWalletBottomSheet(BuildContext context) {
  final store = getIt.get<MyWalletsSrore>();

  sAnalytics.addWalletForFavouritesScreenView();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    then: (isAssetChoosed) {
      if (!((isAssetChoosed as bool?) ?? false)) {
        sAnalytics.tapOnTheButtonCloseOnAddWalletForFavouritesSheet();
      }
    },
    expanded: true,
    pinned: ActionBottomSheetHeader(
      name: intl.my_wallets_add_wallet,
      showSearch: store.currenciesForSearch.length >= 7,
      onChanged: (String value) {
        store.onSearch(value);
      },
      horizontalDividerPadding: 24,
      addPaddingBelowTitle: true,
      isNewDesign: true,
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [_AssetsList()],
  );
}

class _AssetsList extends StatelessObserverWidget {
  _AssetsList();

  final store = getIt.get<MyWalletsSrore>();

  @override
  Widget build(BuildContext context) {
    final currencies = store.currenciesForSearch;

    return Column(
      children: [
        for (final currency in currencies)
          WalletSearchItem(
            icon: SNetworkSvg24(
              url: currency.iconUrl,
            ),
            description: currency.description,
            symbol: currency.symbol,
            onTap: () {
              store.onChooseAsetFromSearch(currency);
              Navigator.of(context).pop(true);
            },
          ),
      ],
    );
  }
}
