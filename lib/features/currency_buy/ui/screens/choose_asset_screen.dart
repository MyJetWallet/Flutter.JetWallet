import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/formatting/base/format_percent.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

import '../../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../../utils/helpers/currencies_helpers.dart';
import '../../../../utils/models/currency_model.dart';
import '../../../actions/helpers/show_currency_search.dart';
import '../../../actions/store/action_search_store.dart';

@RoutePage(name: 'ChooseAssetRouter')
class ChooseAssetScreen extends StatefulObserverWidget {
  const ChooseAssetScreen({super.key, required this.onChooseAsset});

  final void Function(CurrencyModel currency) onChooseAsset;

  @override
  State<ChooseAssetScreen> createState() => _ChooseAssetScreenState();
}

class _ChooseAssetScreenState extends State<ChooseAssetScreen> {
  final searchStore = ActionSearchStore();

  @override
  void initState() {
    super.initState();

    searchStore.searchController = TextEditingController();

    searchStore.init(
      customCurrencies: sSignalRModules.currenciesList,
    );
    searchStore.refreshSearch();

    sAnalytics.chooseWalletScreenView();
  }

  @override
  Widget build(BuildContext context) {
    final showSearch = showBuyCurrencySearch(
      context,
      fromCard: false,
      searchStore: searchStore,
    );
    sortByBalanceAndWeight(searchStore.currencies);

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      header: GlobalBasicAppBar(
        title: intl.choose_asser_screan_header,
        hasRightIcon: false,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (showSearch)
              SPaddingH24(
                child: Column(
                  children: [
                    SInput(
                      controller: searchStore.searchController,
                      label: intl.actionBottomSheetHeader_search,
                      onChanged: (String value) {
                        searchStore.search(value);
                      },
                      height: 44,
                      withoutVerticalPadding: true,
                    ),
                    const SDivider(),
                  ],
                ),
              ),
            Observer(
              builder: (context) {
                return ChooseAssetBody(
                  searchStore: searchStore,
                  onChooseAsset: widget.onChooseAsset,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseAssetBody extends StatelessObserverWidget {
  const ChooseAssetBody({
    required this.searchStore,
    required this.onChooseAsset,
  });

  final ActionSearchStore searchStore;
  final void Function(CurrencyModel currency) onChooseAsset;

  @override
  Widget build(BuildContext context) {
    final baseCurrency = sSignalRModules.baseCurrency;

    final currencyFiltered = List<CurrencyModel>.from(searchStore.fCurrencies);

    sortByWeight(currencyFiltered);

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

    return Column(
      children: [
        for (final currency in currencyFiltered) ...[
          if (currency.type == AssetType.crypto)
            Builder(
              builder: (context) {
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
                  supplement: currency.symbol,
                  isRightValueMarket: true,
                  rightMarketValue: currency.dayPercentChange.toFormatPercentPriceChange(),
                  rightValueMarketPositive: currency.dayPercentChange > 0,
                  onTableAssetTap: () => onChooseAsset(currency),
                );
              },
            ),
        ],
        const SpaceH42(),
      ],
    );
  }
}
