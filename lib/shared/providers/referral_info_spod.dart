import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/referral_info_model.dart';

import 'service_providers.dart';

final referralInfoSpod = StreamProvider.autoDispose<ReferralInfoModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.referralInfo();
});
