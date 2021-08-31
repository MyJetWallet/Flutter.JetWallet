import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../shared/models/currency_model.dart';
import '../../../shared/providers/currencies_pod/currencies_pod.dart';

final currencyPod = Provider.autoDispose.family<CurrencyModel, String>(
  (ref, assetSymbol) {
    final currencies = ref.read(currenciesPod);

    return currencies.firstWhere((currency) => currency.symbol == assetSymbol);
  },
);
