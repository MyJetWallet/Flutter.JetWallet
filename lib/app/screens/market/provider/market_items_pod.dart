import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/helpers/valid_icon_url.dart';
import '../../../shared/providers/base_currency_pod/base_currency_pod.dart';
import '../../../shared/providers/currencies_pod/currencies_pod.dart';
import '../model/market_item_model.dart';
import 'market_references_spod.dart';
import 'search_stpod.dart';

final marketItemsPod = Provider.autoDispose<List<MarketItemModel>>((ref) {
  final references = ref.watch(marketReferencesSpod);
  final search = ref.watch(searchStpod);
  final currencies = ref.watch(currenciesPod);
  final baseCurrency = ref.watch(baseCurrencyPod);

  final items = <MarketItemModel>[];

  references.whenData((value) {
    for (final marketReference in value.references) {
      final currency = currencies.firstWhere((element) {
        return element.symbol == marketReference.associateAsset;
      });

      if (currency.symbol != baseCurrency.symbol) {
        items.add(
          MarketItemModel(
            iconUrl: validIconUrl(marketReference.iconUrl),
            weight: marketReference.weight,
            associateAsset: marketReference.associateAsset,
            associateAssetPair: marketReference.associateAssetPair,
            id: currency.symbol,
            name: currency.description,
            dayPriceChange: currency.dayPriceChange,
            dayPercentChange: currency.dayPercentChange,
            lastPrice: currency.currentPrice,
            assetBalance: currency.assetBalance,
            baseBalance: currency.baseBalance,
            prefixSymbol: currency.prefixSymbol,
            baseCurrencySymbol: currency.baseCurrencySymbol,
            accuracy: currency.accuracy,
            baseCurrencyAccuracy: currency.accuracy,
          ),
        );
      }
    }
  });

  return _formattedItems(items, search.state.text.toLowerCase());
});

List<MarketItemModel> _formattedItems(
  List<MarketItemModel> items,
  String searchInput,
) {
  items.sort((a, b) => b.weight.compareTo(a.weight));

  return items
      .where(
        (item) =>
            item.id.toLowerCase().contains(searchInput) ||
            item.name.toLowerCase().contains(searchInput),
      )
      .toList();
}
