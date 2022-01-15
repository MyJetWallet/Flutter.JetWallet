import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../notifier/operation_history_notipod.dart';

final operationHistoryInitFpod =
    FutureProvider.family.autoDispose<void, String>(
  (ref, assetId) async {
    final transactionHistoryN = ref.read(
      operationHistoryNotipod(
        assetId,
      ).notifier,
    );

    await transactionHistoryN.initOperationHistory();
  },
);
