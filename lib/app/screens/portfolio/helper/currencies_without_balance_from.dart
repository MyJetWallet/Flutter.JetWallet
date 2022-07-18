import '../../../shared/models/currency_model.dart';

List<CurrencyModel> currenciesWithoutBalanceFrom(
  List<CurrencyModel> currencies,
) {
  return currencies
      .where(
        (currency) => currency.isAssetBalanceEmpty && currency.noPendingDeposit,
      )
      .toList()
    ..sort((a, b) => a.weight.compareTo(b.weight));
}
