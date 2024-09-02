import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/features/buy_flow/ui/amount_screen.dart';
import 'package:jetwallet/features/convert_flow/utils/show_convert_to_fiat_bottom_sheet.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/formatting/base/format_percent.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void showConvertToBottomSheet({
  required BuildContext context,
  required CurrencyModel fromAsset,
}) {
  final baseCurrency = sSignalRModules.baseCurrency;

  final currenciesList = [...sSignalRModules.currenciesList];

  currenciesList.removeWhere((element) => element.symbol == fromAsset.symbol);

  final searchStore = ActionSearchStore()..init(customCurrencies: currenciesList);

  final currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);

  final showSearch = currencyFiltered.length >= 7;

  sShowBasicModalBottomSheet(
    context: context,
    pinned: ActionBottomSheetHeader(
      name: intl.convert_amount_convert_to,
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
    scrollable: true,
    expanded: showSearch,
    children: [
      Observer(
        builder: (context) {
          sortByWeight(searchStore.fCurrencies);
          final currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);

          final watchListIds = sSignalRModules.keyValue.watchlist?.value ?? [];

          final favAssets = <CurrencyModel>[];

          for (final symbol in watchListIds) {
            if (currencyFiltered.any((element) => element.symbol == symbol)) {
              favAssets.add(
                currencyFiltered.firstWhere((element) => element.symbol == symbol),
              );
              currencyFiltered.removeWhere((element) => element.symbol == symbol);
            }
          }
          currencyFiltered.insertAll(0, favAssets);

          if (currencyFiltered.any((element) => element.symbol == 'EUR')) {
            final eurAsset = currenciesList.firstWhere((element) => element.symbol == 'EUR');
            currencyFiltered.removeWhere((element) => element.symbol == 'EUR');
            currencyFiltered.insert(0, eurAsset);
          }

          currencyFiltered.removeWhere((element) => element.symbol == fromAsset.symbol);

          return Column(
            children: [
              for (final currency in currencyFiltered) ...[
                Builder(
                  builder: (context) {
                    final isEurAsset = currency.symbol == 'EUR';
                    final marketItem = sSignalRModules.getMarketPrices.firstWhere(
                      (marketItem) => marketItem.symbol == currency.symbol,
                      orElse: () => MarketItemModel.empty(),
                    );

                    return SimpleTableAsset(
                      assetIcon: NetworkIconWidget(
                        currency.iconUrl,
                      ),
                      label: currency.description,
                      rightValue:
                          (baseCurrency.symbol == currency.symbol ? Decimal.one : currency.currentPrice).toFormatPrice(
                        prefix: baseCurrency.prefix,
                        accuracy: marketItem.priceAccuracy,
                      ),
                      supplement: isEurAsset ? null : currency.symbol,
                      isRightValueMarket: true,
                      hasRightValue: !isEurAsset,
                      rightMarketValue: formatPercent(currency.dayPercentChange),
                      rightValueMarketPositive: currency.dayPercentChange > 0,
                      onTableAssetTap: () {
                        if (currency.symbol == 'EUR') {
                          showConvertToFiatBottomSheet(
                            fromAsset: fromAsset,
                            context: context,
                          );
                        } else {
                          sRouter.push(
                            AmountRoute(
                              tab: AmountScreenTab.convert,
                              asset: fromAsset,
                              toAsset: currency,
                            ),
                          );
                        }
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
  );
}
