import 'package:jetwallet/core/services/currencies_service/currencies_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

List<CurrencyModel> getMarketFiats() {
  final items = sSignalRModules.getCurrencies;

  return items.where((item) => item.type == AssetType.fiat).toList();
}
