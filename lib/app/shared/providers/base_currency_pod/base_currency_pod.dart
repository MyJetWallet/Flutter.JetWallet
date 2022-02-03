import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../client_detail_pod/client_detail_spod.dart';
import '../signal_r/assets_spod.dart';
import 'base_currency_model.dart';

final baseCurrencyPod = Provider.autoDispose<BaseCurrencyModel>((ref) {
  ref.maintainState = true;

  final clientDetail = ref.watch(clientDetailSpod);
  final assets = ref.watch(assetsSpod);

  var value = const BaseCurrencyModel();

  clientDetail.whenData((clientDetailData) {
    assets.whenData((assetsData) {
      final elements = assetsData.assets.where((element) {
        return element.symbol == clientDetailData.baseAssetSymbol;
      });

      value = BaseCurrencyModel(
        prefix: elements.isEmpty ? null : elements.first.prefixSymbol,
        symbol: clientDetailData.baseAssetSymbol,
        accuracy: elements.isEmpty ? 0 : elements.first.accuracy.toInt(),
      );
    });
  });

  return value;
});
