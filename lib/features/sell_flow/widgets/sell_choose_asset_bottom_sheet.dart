import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

import '../../../core/di/di.dart';
import '../../../utils/helpers/currencies_helpers.dart';
import '../../../utils/models/currency_model.dart';
import '../../actions/helpers/show_currency_search.dart';
import '../../actions/store/action_search_store.dart';

void showSellChooseAssetBottomSheet({
  required BuildContext context,
  required void Function(CurrencyModel currency) onChooseAsset,
  dynamic Function(dynamic)? then,
}) {
  sAnalytics.sellFromSheetView();

  final searchStore = ActionSearchStore();

  final currenciesList = sSignalRModules.currenciesList;

  searchStore.init(
    customCurrencies: currenciesList,
  );

  final showSearch = showSellCurrencySearch(
    context,
  );

  sortByBalanceAndWeight(searchStore.filteredCurrencies);

  showBasicBottomSheet(
    context: context,
    expanded: showSearch,
    header: BasicBottomSheetHeaderWidget(
      title: intl.amount_screen_sell,
      searchOptions: showSearch
          ? SearchOptions(
              hint: intl.actionBottomSheetHeader_search,
              onChange: (String value) {
                searchStore.search(value);
              },
            )
          : null,
    ),
    children: [
      _ChooseAssetBody(
        searchStore: searchStore,
        onChooseAsset: onChooseAsset,
      ),
    ],
  ).then((value) {
    then?.call(value);
  });
}

class _ChooseAssetBody extends StatelessObserverWidget {
  const _ChooseAssetBody({
    required this.searchStore,
    required this.onChooseAsset,
  });

  final ActionSearchStore searchStore;
  final void Function(CurrencyModel currency) onChooseAsset;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;
    final state = searchStore;

    sortByBalanceAndWeight(searchStore.searchCurrencies);

    return Column(
      children: [
        for (final currency in state.searchCurrencies) ...[
          if (currency.type == AssetType.crypto)
            Builder(
              builder: (context) {
                var secondaryText = '';
                if (baseCurrency.symbol != currency.symbol) {
                  secondaryText =
                      getIt<AppStore>().isBalanceHide ? '******* ${currency.symbol}' : currency.volumeAssetBalance;
                }

                return SimpleTableAsset(
                  key: UniqueKey(),
                  assetIcon: NetworkIconWidget(
                    currency.iconUrl,
                  ),
                  label: currency.description,
                  rightValue: getIt<AppStore>().isBalanceHide
                      ? '**** ${baseCurrency.symbol}'
                      : currency.volumeBaseBalance(baseCurrency),
                  supplement: secondaryText,
                  onTableAssetTap: () {
                    sAnalytics.tapOnSelectedNewSellFromAssetButton(
                      newSellFromAsset: currency.symbol,
                    );
                    onChooseAsset(currency);
                  },
                );
              },
            ),
        ],
        const SpaceH42(),
      ],
    );
  }
}
