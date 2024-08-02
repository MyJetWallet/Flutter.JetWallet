import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';

List<CurrencyModel> nonIndicesWithBalanceFrom(
  List<CurrencyModel> currenciesWithBalance,
) {
  final nonIndicesWithBalance = currenciesWithBalance.where((currency) => currency.type != AssetType.indices).toList();
  sortCurrencies(currenciesWithBalance);

  return nonIndicesWithBalance;
}
