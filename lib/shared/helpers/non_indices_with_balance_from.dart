import 'package:simple_networking/services/signal_r/model/asset_model.dart';

import '../../app/shared/helpers/currencies_helpers.dart';
import '../../app/shared/models/currency_model.dart';

List<CurrencyModel> nonIndicesWithBalanceFrom(
  List<CurrencyModel> currenciesWithBalance,
) {
  final nonIndicesWithBalance = currenciesWithBalance
      .where((currency) => currency.type != AssetType.indices)
      .toList();
  sortCurrencies(currenciesWithBalance);

  return nonIndicesWithBalance;
}
