import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/market/store/watchlist_store.dart';
import 'package:jetwallet/features/market/widgets/add_asset_item_widget.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

Future<void> showAddAssetsBottomSheet(BuildContext context) async {
  final currenciesList = [...sSignalRModules.currenciesList].where((asset) => asset.type == AssetType.crypto).toList()
    ..sort(
      (a, b) => a.weight.compareTo(
        b.weight,
      ),
    );

  final searchStore = ActionSearchStore()..init(customCurrencies: currenciesList);

  final watchlistIdsN = getIt.get<WatchlistStore>();

  sShowBasicModalBottomSheet(
    context: context,
    pinned: ActionBottomSheetHeader(
      name: intl.market_add_assets,
      showSearch: true,
      onChanged: (String value) {
        searchStore.search(value);
      },
      horizontalDividerPadding: 24,
      addPaddingBelowTitle: true,
      isNewDesign: true,
      needBottomPadding: false,
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    expanded: true,
    scrollable: true,
    children: [
      Observer(
        builder: (context) {
          final currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);
          final list = watchlistIdsN.state;

          return Column(
            children: [
              for (final currency in currencyFiltered) ...[
                Builder(
                  builder: (context) {
                    final isInWatchlist = list.contains(currency.symbol);

                    return AddAssetItemWidget(
                      iconUrl: currency.iconUrl,
                      assetDescription: currency.description,
                      assetSymbol: currency.symbol,
                      isFavourite: isInWatchlist,
                      onSave: () {
                        isInWatchlist
                            ? watchlistIdsN.removeFromWatchlist(currency.symbol)
                            : watchlistIdsN.addToWatchlist(currency.symbol);
                      },
                    );
                  },
                ),
              ],
            ],
          );
        },
      ),
      const SpaceH42(),
    ],
    pinnedBottom: Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).padding.bottom + 32,
      ),
      child: SButton.black(
        text: intl.market_done,
        callback: () {
          sRouter.maybePop();
        },
      ),
    ),
  );
}
