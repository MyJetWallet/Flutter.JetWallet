import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../service/services/wallet/model/asset_converter_map_model.dart';
import '../../../../service_providers.dart';

final converterMapFpod = FutureProvider<AssetConverterMapModel>((ref) {
  final walletService = ref.watch(walletServicePod);

  return walletService.assetConverterMap('USD');
});
