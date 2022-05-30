import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/asset_model.dart';

import '../../../shared/models/currency_model.dart';
import '../../../shared/providers/currencies_pod/currencies_pod.dart';

final marketCryptoPod = Provider.autoDispose<List<CurrencyModel>>((ref) {
  final items = ref.watch(currenciesPod);
  final cryptos = items.where((item) => item.type == AssetType.crypto).toList();

  return cryptos;
});
