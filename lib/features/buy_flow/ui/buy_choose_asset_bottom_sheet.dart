import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/choose_asset_screen.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';

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

  showBasicBottomSheet(
    context: context,
    expanded: true,
    header: BasicBottomSheetHeaderWidget(
      title: intl.choose_asser_screan_header,
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
        onChooseAsset: onChooseAsset,
      ),
    ],
  );
}
