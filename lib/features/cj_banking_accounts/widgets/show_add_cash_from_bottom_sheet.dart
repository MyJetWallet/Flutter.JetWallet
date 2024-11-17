import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

import '../../../core/di/di.dart';
import '../../app/store/app_store.dart';

void showAddCashFromBottomSheet({
  required BuildContext context,
  required VoidCallback onClose,
  required void Function(CurrencyModel currency) onChooseAsset,
  String? skipAsset,
}) {
  sAnalytics.addCashFromTrScreenView();

  final baseCurrency = sSignalRModules.baseCurrency;

  final initAssetsList = [
    ...sSignalRModules.currenciesList.where((element) => element.symbol != skipAsset),
  ];

  final searchStore = ActionSearchStore()..init(customCurrencies: initAssetsList);

  var currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);
  currencyFiltered = currencyFiltered
      .where(
        (element) => element.type == AssetType.crypto,
      )
      .toList();

  final showSearch = currencyFiltered.length >= 7;

  showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.wallet_choose_asset_from_convert,
      searchOptions: showSearch
          ? SearchOptions(
              hint: intl.actionBottomSheetHeader_search,
              onChange: (String value) {
                searchStore.search(value);
              },
            )
          : null,
    ),
    onDismiss: onClose,
    expanded: showSearch,
    children: [
      Observer(
        builder: (context) {
          var currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);
          currencyFiltered = currencyFiltered
              .where(
                (element) => element.type == AssetType.crypto,
              )
              .toList();

          final watchList = sSignalRModules.keyValue.watchlist?.value ?? [];
          sortByBalanceWatchlistAndWeight(currencyFiltered, watchList);

          return Column(
            children: [
              for (final currency in currencyFiltered) ...[
                SimpleTableAccount(
                  assetIcon: NetworkIconWidget(
                    currency.iconUrl,
                  ),
                  label: currency.description,
                  supplement:
                      getIt<AppStore>().isBalanceHide ? '******* ${currency.symbol}' : currency.volumeAssetBalance,
                  rightValue: getIt<AppStore>().isBalanceHide
                      ? '**** ${baseCurrency.symbol}'
                      : currency.volumeBaseBalance(baseCurrency),
                  onTableAssetTap: () {
                    sAnalytics.tapOnTheAnyCryptoForDepositButton(
                      cryptoAsset: currency.symbol,
                    );
                    onChooseAsset(currency);
                  },
                ),
              ],
            ],
          );
        },
      ),
      const SpaceH42(),
    ],
  );
}
