import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../screens/market/model/currency_model.dart';
import '../../../screens/market/provider/currencies_pod.dart';
import '../client_detail_pod/client_detail_pod.dart';

final baseAssetPod = Provider.autoDispose<CurrencyModel>((ref) {
  final clientDetail = ref.watch(clientDetailPod);
  final currencies = ref.watch(currenciesPod);

  final baseAsset = currencies.where(
    (element) => element.symbol == clientDetail.baseAssetSymbol,
  );

  return baseAsset.first;
});
