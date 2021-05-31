import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/service/model/wallet/balance_model.dart';
import '../../../../service_providers.dart';

final balancesSpod = StreamProvider<BalancesModel>((ref) {
  final signalRService = ref.watch(signalRServicePod);

  return signalRService.balances();
});
