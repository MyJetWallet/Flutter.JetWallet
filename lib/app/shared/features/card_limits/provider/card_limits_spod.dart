import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/card_limits_model.dart';

import '../../../../../shared/providers/service_providers.dart';

final cardLimitsSpod =
StreamProvider.autoDispose<CardLimitsModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.cardLimits();
});
