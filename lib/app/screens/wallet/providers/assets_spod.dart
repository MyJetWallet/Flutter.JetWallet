import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/service/model/wallet/asset_model.dart';
import '../../../../service_providers.dart';

final assetsSpod = StreamProvider<AssetsModel>((ref) {
  final signalRService = ref.watch(signalRServicePod);

  return signalRService.getAssetsStream();
});
