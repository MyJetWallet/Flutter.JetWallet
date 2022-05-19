import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/helpers/icon_url_from.dart';
import '../../../shared/models/currency_model.dart';
import '../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../model/market_item_model.dart';
import '../notifier/search/search_notipod.dart';
import 'market_references_spod.dart';

final marketItemsPod = Provider.autoDispose<List<MarketItemModel>>((ref) {
  final references = ref.watch(marketReferencesSpod);
  final search = ref.watch(searchNotipod);
  final currencies = ref.watch(currenciesPod);
  final baseCurrency = ref.watch(baseCurrencyPod);

  final items = <MarketItemModel>[];

  references.whenData((value) {
    for (final marketReference in value.references) {
      late CurrencyModel currency;
      try {
        currency = currencies.firstWhere(
          (element) {
            return element.symbol == marketReference.associateAsset;
          },
        );
      } catch (_) {
        continue;
      }

      if (currency.symbol != baseCurrency.symbol) {
        items.add(
          MarketItemModel(
            iconUrl: iconUrlFrom(assetSymbol: currency.symbol),
            weight: marketReference.weight,
            associateAsset: marketReference.associateAsset,
            associateAssetPair: marketReference.associateAssetPair,
            symbol: currency.symbol,
            name: currency.description,
            dayPriceChange: currency.dayPriceChange,
            dayPercentChange: currency.dayPercentChange,
            lastPrice: currency.currentPrice,
            assetBalance: currency.assetBalance,
            baseBalance: currency.baseBalance,
            prefixSymbol: currency.prefixSymbol,
            assetAccuracy: currency.accuracy,
            priceAccuracy: marketReference.priceAccuracy,
            startMarketTime: marketReference.startMarketTime,
            type: currency.type,
          ),
        );
      }
    }
  });

  return _formattedItems(items, search.search);
});

List<MarketItemModel> _formattedItems(
  List<MarketItemModel> items,
  String searchInput,
) {
  items.sort((a, b) => a.weight.compareTo(b.weight));

  return items
      .where(
        (item) =>
            item.symbol.toLowerCase().contains(searchInput) ||
            item.name.toLowerCase().contains(searchInput),
      )
      .toList();
}
