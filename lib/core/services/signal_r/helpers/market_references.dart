import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/helpers/icon_url_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/market_references_model.dart';

List<MarketItemModel> marketReferencesList(
  MarketReferencesModel? value,
  List<CurrencyModel> currencies,
) {
  final items = <MarketItemModel>[];

  if (value == null) return items;

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

    if (currency.symbol != sSignalRModules.baseCurrency.symbol) {
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
          sectorIds: marketReference.sectorIds,
          marketCap: marketReference.marketCap,
        ),
      );
    }
  }

  return _formattedItems(
    items,
    '',
  );
}

List<MarketItemModel> _formattedItems(
  List<MarketItemModel> items,
  String searchInput,
) {
  items.sort((a, b) => a.weight.compareTo(b.weight));

  return items
      .where(
        (item) => item.symbol.toLowerCase().contains(searchInput) || item.name.toLowerCase().contains(searchInput),
      )
      .toList();
}
