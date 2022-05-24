import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/earn_offers_model.dart';

import '../../../../../shared/providers/service_providers.dart';

final earnOffersSpod =
StreamProvider.autoDispose<EarnOffersModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.earnOffers();
});
