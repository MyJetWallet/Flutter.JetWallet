import '../../app/shared/helpers/currencies_helpers.dart';
import '../../app/shared/models/currency_model.dart';
import '../../service/services/signal_r/model/asset_model.dart';

List<CurrencyModel> nonIndicesCurrenciesWithBalanceFrom(
  List<CurrencyModel> currenciesWithBalance,
) {
  final nonIndicesCurrenciesWithBalance = currenciesWithBalance
      .where((currency) => currency.type != AssetType.indices)
      .toList();
  sortCurrencies(currenciesWithBalance);

  return nonIndicesCurrenciesWithBalance;
}
