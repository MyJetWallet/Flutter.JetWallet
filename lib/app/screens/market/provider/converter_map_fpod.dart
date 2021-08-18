import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/wallet/model/asset_converter_map/asset_converter_map_model.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../shared/providers/client_detail_pod/client_detail_pod.dart';

final converterMapFpod = FutureProvider.autoDispose<AssetConverterMapModel>(
  (ref) {
    final walletService = ref.watch(walletServicePod);
    final clientDetail = ref.watch(clientDetailPod);

    return walletService.assetConverterMap(clientDetail.baseAssetSymbol);
  },
);
