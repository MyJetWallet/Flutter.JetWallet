import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/choose_asset_screen.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../utils/helpers/currencies_helpers.dart';
import '../../../utils/models/currency_model.dart';
import '../../actions/helpers/show_currency_search.dart';
import '../../actions/store/action_search_store.dart';

void showConvertToChooseAssetBottomSheet({
  required BuildContext context,
  required void Function(CurrencyModel currency) onChooseAsset,
  String? skipAssetSymbol,
  dynamic Function(dynamic)? then,
}) {
  sAnalytics.convertToSheetView();
  final searchStore = ActionSearchStore();
  final currenciesList = sSignalRModules.currenciesList.where((currency) {
    return currency.symbol != skipAssetSymbol;
  }).toList();

  searchStore.init(
    customCurrencies: currenciesList,
  );
  final showSearch = showConverToCurrencySearch(
    context,
  );
  sortByBalanceAndWeight(searchStore.filteredCurrencies);

  showBasicBottomSheet(
    context: context,
    expanded: true,
    header: BasicBottomSheetHeaderWidget(
      title: intl.convert_amount_convert_to,
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
      ChooseAssetBody(
        searchStore: searchStore,
        onChooseAsset: (currency) {
          sAnalytics.tapOnSelectedNewConvertToButton(
            newConvertToAsset: currency.symbol,
          );
          onChooseAsset.call(currency);
        },
      ),
    ],
  ).then((value) {
    if (value != true) {
      sAnalytics.tapOnCloseSheetConvertToButton();
    }
    then?.call(value);
  });
}
