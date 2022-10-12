import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

List<CurrencyModel> getMarketFiats(List<CurrencyModel> items) {
  return items.where((item) => item.type == AssetType.fiat).toList();
}
