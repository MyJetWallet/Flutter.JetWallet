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
  }) : super([]);

  final Reader read;

  static final _logger = Logger('OperationHistoryNotifier');

  Future<void> initOperationHistory(
    String assetId,
  ) async {
    _logger.log(notifier, 'initOperationHistory');

    try {
      final operationHistory = await _requestOperationHistory(
        OperationHistoryRequestModel(
          assetId: assetId,
          batchSize: 5,
        ),
      );

      state = _filterUnusedOperationTypeItemsFrom(
        operationHistory.operationHistory,
      );
    } catch (e) {
      _logger.log(stateFlow, 'initOperationHistory', e);
    }
  }

  Future<void> operationHistory(String assetId) async {
    _logger.log(notifier, 'operationHistory');

    try {
      final operationHistory = await _requestOperationHistory(
        OperationHistoryRequestModel(
          assetId: assetId,
          batchSize: 5,
          lastDate: state.last.timeStamp,
        ),
      );

      updateOperationHistory(operationHistory.operationHistory);
    } catch (e) {
      _logger.log(stateFlow, 'operationHistory', e);
    }
  }

  void updateOperationHistory(List<OperationHistoryItem> items) {
    _logger.log(notifier, 'updateOperationHistory');

    state = state + _filterUnusedOperationTypeItemsFrom(items);
  }

  Future<OperationHistoryResponseModel> _requestOperationHistory(
    OperationHistoryRequestModel model,
  ) =>
      read(operationHistoryServicePod).operationHistory(
        model,
      );
}

// TODO(Vova): remove when all types will be properly sorted on the backend.
List<OperationHistoryItem> _filterUnusedOperationTypeItemsFrom(
  List<OperationHistoryItem> items,
) {
  final filteredItems = items
      .where(
    (item) =>
        item.operationType == OperationType.deposit ||
        item.operationType == OperationType.unknown ||
        item.operationType == OperationType.withdraw ||
        item.operationType == OperationType.swap ||
        item.operationType == OperationType.transferByPhone ||
        item.operationType == OperationType.receiveByPhone,
  )
      .map((item) {
    if (item.operationType == OperationType.swap) {
      return item.copyWith(
        operationType:
            item.swapInfo!.isSell ? OperationType.sell : OperationType.buy,
      );
    } else {
      return item;
    }
  }).toList();

  filteredItems.sort(
    (a, b) => DateTime.parse('${b.timeStamp}Z')
        .toLocal()
        .compareTo(DateTime.parse('${a.timeStamp}Z').toLocal()),
  );

  return filteredItems;
}
