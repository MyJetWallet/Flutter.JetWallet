import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/balance_model.dart';
import '../../../../service_providers.dart';

final balancesSpod = StreamProvider.autoDispose<BalancesModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.balances();
});
