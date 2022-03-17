import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/blockchains_model.dart';
import '../../../../shared/providers/service_providers.dart';

final blockchainsSpod = StreamProvider.autoDispose<BlockchainsModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.blockchains();
});
