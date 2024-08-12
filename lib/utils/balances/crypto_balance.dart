import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

String calculateCryptoBalance() {
  final currenciesList = sSignalRModules.currenciesList.where((element) => element.type == AssetType.crypto);
  final baseCurrency = sSignalRModules.baseCurrency;
  var totalBalance = Decimal.zero;

  for (final item in currenciesList) {
    totalBalance += item.baseBalance;
  }

  return totalBalance.toFormatSum(
    accuracy: baseCurrency.accuracy,
    symbol: baseCurrency.symbol,
  );
}
