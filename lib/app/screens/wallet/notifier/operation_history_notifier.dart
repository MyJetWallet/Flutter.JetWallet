import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../service/services/operation_history/model/operation_history_request_model.dart';
import '../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/providers/service_providers.dart';

class OperationHistoryNotifier
    extends StateNotifier<List<OperationHistoryItem>> {
  OperationHistoryNotifier({
    required this.read,
  }) : super(
          [],
        );

  final Reader read;

  static final _logger = Logger('OperationHistoryNotifier');

  Future<void> initOperationHistory(
    String assetId,
  ) async {
    _logger.log(notifier, 'initOperationHistory');

    try {
      final operationHistory = await _requestOperationHistory(assetId);

      state = operationHistory.operationHistory;
    } catch (e) {
      _logger.log(stateFlow, 'initOperationHistory', e);
    }
  }

  Future<void> operationHistory(String assetId) async {
    _logger.log(notifier, 'operationHistory');

    try {
      final operationHistory = await _requestOperationHistory(assetId);

      updateOperationHistory(operationHistory.operationHistory);
    } catch (e) {
      _logger.log(stateFlow, 'operationHistory', e);
    }
  }

  void updateOperationHistory(List<OperationHistoryItem> items) {
    state = state + items;
  }

  Future<OperationHistoryResponseModel> _requestOperationHistory(
          String assetId) =>
      read(operationHistoryServicePod).operationHistory(
        OperationHistoryRequestModel(
          assetId: assetId,
          batchSize: 5,
          lastDate: state.first.timeStamp,
        ),
      );
}
