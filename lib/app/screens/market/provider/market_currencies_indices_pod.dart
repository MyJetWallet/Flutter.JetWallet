import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/models/currency_model.dart';
import 'package:jetwallet/app/shared/providers/currencies_pod/currencies_pod.dart';
import 'package:jetwallet/service/services/signal_r/model/asset_model.dart';

final marketCurrenciesIndicesPod =
    Provider.autoDispose<List<CurrencyModel>>((ref) {
  final items = ref.watch(currenciesPod);
  final indices =
      items.where((item) => item.type == AssetType.indices).toList();

  return indices;
});
