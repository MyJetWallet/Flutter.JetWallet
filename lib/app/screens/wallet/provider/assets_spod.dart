import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/asset_model.dart';
import '../../../../shared/providers/service_providers.dart';

final assetsSpod = StreamProvider.autoDispose<AssetsModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.assets();
});
