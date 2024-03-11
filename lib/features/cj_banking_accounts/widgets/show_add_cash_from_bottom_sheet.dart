import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

import '../../../core/di/di.dart';
import '../../app/store/app_store.dart';

void showAddCashFromBottomSheet({
  required BuildContext context,
  required VoidCallback onClose,
  required void Function(CurrencyModel currency) onChooseAsset,
}) {
  sAnalytics.addCashFromTrScreenView();

  final baseCurrency = sSignalRModules.baseCurrency;

  final searchStore = ActionSearchStore();

  var currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);
  currencyFiltered = currencyFiltered
      .where(
        (element) => element.isAssetBalanceNotEmpty && element.type == AssetType.crypto,
      )
      .toList();

  final showSearch = currencyFiltered.length >= 7;

  sShowBasicModalBottomSheet(
    context: context,
    pinned: ActionBottomSheetHeader(
      name: intl.add_cash_from,
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
    onDissmis: onClose,
    scrollable: true,
    expanded: showSearch,
    children: [
      if (sSignalRModules.currenciesList
          .where((element) => element.symbol != 'EUR' && element.isAssetBalanceNotEmpty)
          .isEmpty)
        Builder(
          builder: (context) {
            final currency = sSignalRModules.currenciesList.firstWhere((element) => element.symbol == 'USDT');

            return SimpleTableAccount(
              assetIcon: SNetworkSvg24(
                url: currency.iconUrl,
              ),
              label: currency.description,
              supplement: getIt<AppStore>().isBalanceHide
                  ? '******* ${currency.symbol}'
                  : currency.volumeAssetBalance,
              rightValue: getIt<AppStore>().isBalanceHide
                  ? '**** ${baseCurrency.symbol}'
                  : currency.volumeBaseBalance(baseCurrency),
              onTableAssetTap: () {
                sAnalytics.tapOnTheAnyCryptoForDepositButton(cryptoAsset: currency.symbol);
                onChooseAsset(currency);
              },
            );
          },
        )
      else
        Observer(
          builder: (context) {
            var currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);
            currencyFiltered = currencyFiltered
                .where(
                  (element) => element.isAssetBalanceNotEmpty && element.type == AssetType.crypto,
                )
                .toList();

            return Column(
              children: [
                for (final currency in currencyFiltered) ...[
                  if (currency.isAssetBalanceNotEmpty)
                    SimpleTableAccount(
                      assetIcon: SNetworkSvg24(
                        url: currency.iconUrl,
                      ),
                      label: currency.description,
                      supplement: getIt<AppStore>().isBalanceHide
                          ? '******* ${currency.symbol}'
                          : currency.volumeAssetBalance,
                      rightValue: getIt<AppStore>().isBalanceHide
                        ? '**** ${baseCurrency.symbol}'
                        : currency.volumeBaseBalance(baseCurrency),
                      onTableAssetTap: () {
                        sAnalytics.tapOnTheAnyCryptoForDepositButton(cryptoAsset: currency.symbol);
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
