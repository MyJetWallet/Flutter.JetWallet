import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/balance_model.dart';

import '../../../../shared/providers/service_providers.dart';

final balancesSpod = StreamProvider.autoDispose<BalancesModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.balances();
});
