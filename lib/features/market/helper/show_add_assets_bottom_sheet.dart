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
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

Future<void> showAddAssetsBottomSheet(BuildContext context) async {
  final currenciesList = [...sSignalRModules.currenciesList]
      .where((asset) => asset.type == AssetType.crypto && asset.symbol == 'BTC')
      .toList()
    ..sort(
      (a, b) => a.weight.compareTo(
        b.weight,
      ),
    );

  final searchStore = ActionSearchStore()..init(customCurrencies: currenciesList);

  final watchlistIdsN = getIt.get<WatchlistStore>();

  await showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.market_add_assets,
      searchOptions: SearchOptions(
        hint: intl.actionBottomSheetHeader_search,
        onChange: (String value) {
          searchStore.search(value);
        },
      ),
    ),
    button: BasicBottomSheetButton(
      title: intl.market_done,
      onTap: () {
        sRouter.maybePop();
      },
    ),
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
    ],
  );
}
