import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/actions/store/action_search_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../core/services/signal_r/signal_r_service_new.dart';
import '../../../utils/formatting/base/format_percent.dart';
import '../../../widgets/empty_search_result.dart';

void showCryptoSearch(BuildContext context) {
  getIt.get<ActionSearchStore>().initMarket();
  final searchStore = getIt.get<ActionSearchStore>();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    removeBarPadding: true,
    expanded: true,
    pinned: ActionBottomSheetHeader(
      name: '',
      showSearchWithArrow: true,
      hideTitle: true,
      onChanged: (String value) {
        searchStore.searchMarket(value);
      },
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    children: [
      _ActionCryptoSearch(
        searchStore: searchStore,
      ),
    ],
  );
}

class _ActionCryptoSearch extends StatelessObserverWidget {
  const _ActionCryptoSearch({
    required this.searchStore,
  });

  final ActionSearchStore searchStore;

  @override
  Widget build(BuildContext context) {
    final state = searchStore;
    final baseCurrency = sSignalRModules.baseCurrency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.filteredMarketCurrencies.isNotEmpty)
          SPaddingH24(
            child: Text(
              state.filteredMarketCurrencies.length == state.marketCurrencies.length
                  ? intl.market_search_popular
                  : intl.market_search_results,
              style: sTextH4Style,
              textAlign: TextAlign.left,
            ),
          ),
        if (state.filteredMarketCurrencies.length != state.marketCurrencies.length)
          for (final currency in state.filteredMarketCurrencies)
            SimpleTableAsset(
              assetIcon: NetworkIconWidget(
                currency.iconUrl,
              ),
              label: currency.name,
              rightValue: currency.lastPrice.toFormatPrice(
                prefix: baseCurrency.prefix,
                accuracy: currency.priceAccuracy,
              ),
              supplement: currency.symbol,
              rightMarketValue: formatPercent(currency.dayPercentChange),
              isRightValueMarket: true,
              rightValueMarketPositive: currency.dayPercentChange > 0,
              onTableAssetTap: () {
                Navigator.pop(context);
                sRouter.push(
                  MarketDetailsRouter(
                    marketItem: currency,
                  ),
                );
              },
            )
        else
          for (var i = 0; i < 3; i++)
            SimpleTableAsset(
              assetIcon: NetworkIconWidget(
                state.filteredMarketCurrencies[i].iconUrl,
              ),
              label: state.filteredMarketCurrencies[i].name,
              rightValue: state.filteredMarketCurrencies[i].lastPrice.toFormatPrice(
                prefix: baseCurrency.prefix,
                accuracy: state.filteredMarketCurrencies[i].priceAccuracy,
              ),
              supplement: state.filteredMarketCurrencies[i].symbol,
              rightMarketValue: formatPercent(state.filteredMarketCurrencies[i].dayPercentChange),
              rightValueMarketPositive: state.filteredMarketCurrencies[i].dayPercentChange > 0,
              isRightValueMarket: true,
              onTableAssetTap: () {
                Navigator.pop(context);
                sRouter.push(
                  MarketDetailsRouter(
                    marketItem: state.filteredMarketCurrencies[i],
                  ),
                );
              },
            ),
        if (state.filteredMarketCurrencies.isEmpty)
          EmptySearchResult(
            text: state.searchValue,
          )
        else
          const SpaceH24(),
      ],
    );
  }
}
