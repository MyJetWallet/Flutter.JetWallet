import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/operation_history/model/operation_history_request_model.dart';
import '../../../../shared/providers/service_providers.dart';
import '../notifier/operation_history_notipod.dart';

final operationHistoryInitFpod =
    FutureProvider.family.autoDispose<void, String>((ref, assetId) async {
  final operationHistoryService = ref.watch(operationHistoryServicePod);
  final notifier = ref.watch(operationHistoryNotipod.notifier);

  final operationHistory = await operationHistoryService.operationHistory(
    OperationHistoryRequestModel(
      assetId: assetId,
      batchSize: 5,
    ),
  );

  notifier.updateOperationHistory(operationHistory.operationHistory);
});
