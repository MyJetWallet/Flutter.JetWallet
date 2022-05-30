import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/earn_profile_model.dart';

import '../../../../../shared/providers/service_providers.dart';

final earnProfileSpod =
StreamProvider.autoDispose<EarnProfileModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.earnProfile();
});
