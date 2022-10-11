import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

List<CurrencyModel> getMarketCurrencies(List<CurrencyModel> items) {
  return items.where((item) => item.type == AssetType.indices).toList();
}
