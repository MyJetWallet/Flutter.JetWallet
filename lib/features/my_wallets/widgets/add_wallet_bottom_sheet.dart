import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/my_wallets/store/my_wallets_srore.dart';
import 'package:jetwallet/features/my_wallets/widgets/wallet_search_item.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void showAddWalletBottomSheet(BuildContext context) {
  final store = MyWalletsSrore.of(context);

  sAnalytics.addWalletForFavouritesScreenView();

  showBasicBottomSheet(
    context: context,
    expanded: true,
    header: BasicBottomSheetHeaderWidget(
      title: intl.my_wallets_add_wallet,
      searchOptions: store.currenciesForSearch.length >= 7
          ? SearchOptions(
              hint: intl.actionBottomSheetHeader_search,
              onChange: (String value) {
                store.onSearch(value);
              },
            )
          : null,
    ),
    children: [
      _AssetsList(
        contextWithMyWalletsSrore: context,
      ),
    ],
  ).then((isAssetChoosed) {
    final isAssetChoosedTemp = (isAssetChoosed as bool?) ?? false;
    if (!isAssetChoosedTemp) {
      store.onCloseSearchBottomSheetWithoutChoose();
      sAnalytics.walletsScreenView(
        favouritesAssetsList: List.generate(
          store.currencies.length,
          (index) => store.currencies[index].symbol,
        ),
      );
    }
  });
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
