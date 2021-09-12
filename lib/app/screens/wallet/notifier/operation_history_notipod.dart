import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/operation_history/model/operation_history_response_model.dart';
import 'operation_history_notifier.dart';

final operationHistoryNotipod = StateNotifierProvider.autoDispose<
    OperationHistoryNotifier, List<OperationHistoryItem>>(
  (ref) {
    return OperationHistoryNotifier(
      read: ref.read,
    );
  },
);
