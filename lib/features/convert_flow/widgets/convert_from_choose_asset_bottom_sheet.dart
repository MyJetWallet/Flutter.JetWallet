import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

import '../../../core/di/di.dart';
import '../../../utils/helpers/currencies_helpers.dart';
import '../../../utils/models/currency_model.dart';
import '../../actions/helpers/show_currency_search.dart';
import '../../actions/store/action_search_store.dart';

void showConvertFromChooseAssetBottomSheet({
  required BuildContext context,
  required void Function(CurrencyModel currency) onChooseAsset,
  String? skipAssetSymbol,
}) {
  final searchStore = getIt.get<ActionSearchStore>();
  final currenciesList = sSignalRModules.currenciesList.where((currency) {
    return (currency.assetBalance != Decimal.zero) && (currency.symbol != skipAssetSymbol);
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
    expanded: showSearch,
    pinned: ActionBottomSheetHeader(
      name: intl.convert_amount_convert,
      showSearch: showSearch,
      onChanged: (String value) {
        searchStore.search(value);
      },
      horizontalDividerPadding: 24,
      addPaddingBelowTitle: true,
      needBottomPadding: false,
      isNewDesign: true,
    ),
    horizontalPinnedPadding: 0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [
      _ChooseAssetBody(
        searchStore: searchStore,
        onChooseAsset: onChooseAsset,
      ),
    ],
  );
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

    return Column(
      children: [
        for (final currency in state.buyFromCardCurrencies) ...[
          if (currency.type == AssetType.crypto)
            Builder(
              builder: (context) {
                var secondaryText = '';
                if (baseCurrency.symbol != currency.symbol) {
                  secondaryText = getIt<AppStore>().isBalanceHide ? currency.symbol : currency.volumeAssetBalance;
                }

                return SWalletItem(
                  height: 80,
                  key: UniqueKey(),
                  isBalanceHide: getIt<AppStore>().isBalanceHide,
                  decline: currency.dayPercentChange.isNegative,
                  icon: SNetworkSvg24(
                    url: currency.iconUrl,
                  ),
                  baseCurrencySymbol: baseCurrency.symbol,
                  primaryText: currency.description,
                  amount: currency.volumeBaseBalance(baseCurrency),
                  secondaryText: secondaryText,
                  onTap: () {
                    onChooseAsset(currency);
                  },
                  removeDivider: true,
                  isPendingDeposit: currency.isPendingDeposit,
                  priceFieldHeight: 44,
                );
              },
            ),
        ],
        const SpaceH42(),
      ],
    );
  }
}