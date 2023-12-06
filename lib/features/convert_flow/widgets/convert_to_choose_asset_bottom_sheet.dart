import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/choose_asset_screen.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';
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
  final searchStore = getIt.get<ActionSearchStore>();
  final currenciesList = sSignalRModules.currenciesList.where((currency) {
    return currency.symbol != skipAssetSymbol;
  }).toList();

  searchStore.init(
    customCurrencies: currenciesList,
  );
  final showSearch = showBuyCurrencySearch(
    context,
    fromCard: true,
    searchStore: searchStore,
  );
  sortByBalanceAndWeight(searchStore.filteredCurrencies);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    expanded: true,
    then: then,
    pinned: ActionBottomSheetHeader(
      name: intl.convert_amount_convert_to,
      showSearch: showSearch,
      onChanged: (String value) {
        searchStore.search(value);
      },
      horizontalDividerPadding: 24,
      addPaddingBelowTitle: true,
      isNewDesign: true,
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [
      ChooseAssetBody(
        searchStore: searchStore,
        onChooseAsset: onChooseAsset,
      ),
    ],
  );
}
