import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../models/currency_model.dart';
import '../../../providers/currencies_pod/currencies_pod.dart';
import '../../market_details/helper/currency_from.dart';

final currentAssetStpod =
    StateProvider.autoDispose.family<CurrencyModel, String>((ref, assetId) {
  final currentAsset = currencyFrom(ref.read(currenciesPod), assetId);

  return currentAsset;
});
