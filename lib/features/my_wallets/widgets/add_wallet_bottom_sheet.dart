import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/wallet_search_item.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

void showAddWalletBottomSheet(BuildContext context) {
  final store = MyWalletsSrore.of(context);

  sAnalytics.addWalletForFavouritesScreenView();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    then: (isAssetChoosed) {
      final isAssetChoosedTemp = (isAssetChoosed as bool?) ?? false;
      if (!isAssetChoosedTemp) {
        sAnalytics.tapOnTheButtonCloseOnAddWalletForFavouritesSheet();
        store.onCloseSearchBottomSheetWithoutChoose();
        sAnalytics.walletsScreenView(
          favouritesAssetsList: List.generate(
            store.currencies.length,
            (index) => store.currencies[index].symbol,
          ),
        );
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
    children: [
      _AssetsList(
        contextWithMyWalletsSrore: context,
      ),
    ],
  );
}

class _AssetsList extends StatelessObserverWidget {
  const _AssetsList({
    required this.contextWithMyWalletsSrore,
  });

  final BuildContext contextWithMyWalletsSrore;

  @override
  Widget build(BuildContext context) {
    final store = MyWalletsSrore.of(contextWithMyWalletsSrore);

    final currencies = store.currenciesForSearch;

    return Column(
      children: [
        for (final currency in currencies)
          WalletSearchItem(
            icon: NetworkIconWidget(
              currency.iconUrl,
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
