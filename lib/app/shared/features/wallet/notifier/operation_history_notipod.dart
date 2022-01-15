import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'operation_history_notifier.dart';
import 'operation_history_state.dart';

final operationHistoryNotipod = StateNotifierProvider.autoDispose
    .family<OperationHistoryNotifier, OperationHistoryState, String>(
  (ref, assetId) {
    return OperationHistoryNotifier(
      read: ref.read,
      assetId: assetId,
    );
  },
);
