import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../screens/market/provider/assets_spod.dart';
import '../client_detail_pod/client_detail_spod.dart';
import 'base_currency_model.dart';

final baseCurrencyPod = Provider.autoDispose<BaseCurrencyModel>((ref) {
  ref.maintainState = true;

  final clientDetail = ref.watch(clientDetailSpod);
  final assets = ref.watch(assetsSpod);

  var value = const BaseCurrencyModel(
    symbol: 'USD',
    accuracy: 2,
  );

  clientDetail.whenData((clientDetailData) {
    assets.whenData((assetsData) {
      final asset = assetsData.assets.where((element) {
        return element.symbol == clientDetailData.baseAssetSymbol;
      }).first;

      value = BaseCurrencyModel(
        symbol: clientDetailData.baseAssetSymbol,
        accuracy: asset.accuracy,
      );
    });
  });

  return value;
});
