import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/choose_asset_screen.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../core/di/di.dart';
import '../../../utils/helpers/currencies_helpers.dart';
import '../../../utils/models/currency_model.dart';
import '../../actions/helpers/show_currency_search.dart';
import '../../actions/store/action_search_store.dart';

void showBuyChooseAssetBottomSheet({
  required BuildContext context,
  required void Function(CurrencyModel currency) onChooseAsset,
}) {
  final searchStore = getIt.get<ActionSearchStore>();
  searchStore.init();
  searchStore.refreshSearch();
  final showSearch = showBuyCurrencySearch(
    context,
    fromCard: false,
    searchStore: searchStore,
  );

  searchStore.init();
  sortByBalanceAndWeight(searchStore.filteredCurrencies);

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    expanded: true,
    pinned: ActionBottomSheetHeader(
      name: intl.choose_asser_screan_header,
      showSearch: showSearch,
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
    children: [
      ChooseAssetBody(
        searchStore: searchStore,
        onChooseAsset: onChooseAsset,
      ),
    ],
  );
}
