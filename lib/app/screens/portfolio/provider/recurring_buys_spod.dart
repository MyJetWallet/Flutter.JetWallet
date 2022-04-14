import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/signal_r/model/recurring_buys_response_model.dart';
import '../../../../shared/providers/service_providers.dart';

final recurringBuySpod =
    StreamProvider.autoDispose<RecurringBuysResponseModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  final response = signalRService.recurringBuy();

  return response;
});
