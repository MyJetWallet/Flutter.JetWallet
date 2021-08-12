import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/client_detail_model.dart';
import '../../../../shared/providers/service_providers.dart';

final clientDetailSpod = StreamProvider.autoDispose<ClientDetailModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.clientDetail();
});
