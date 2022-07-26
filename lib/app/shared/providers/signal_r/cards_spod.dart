import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/cards_model.dart';

import '../../../../shared/providers/service_providers.dart';

final cardsSpod =
    StreamProvider.autoDispose<CardsModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.cards();
});
