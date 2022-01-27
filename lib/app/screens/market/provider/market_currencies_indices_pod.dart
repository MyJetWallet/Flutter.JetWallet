import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/asset_model.dart';
import '../../../shared/models/currency_model.dart';
import '../../../shared/providers/currencies_pod/currencies_pod.dart';

final marketCurrenciesIndicesPod =
    Provider.autoDispose<List<CurrencyModel>>((ref) {
  final items = ref.watch(currenciesPod);
  final indices =
      items.where((item) => item.type == AssetType.indices).toList();

  return indices;
});
