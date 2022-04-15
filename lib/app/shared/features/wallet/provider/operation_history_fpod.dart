import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../notifier/operation_history_notipod.dart';

final operationHistoryInitFpod =
    FutureProvider.family.autoDispose<void, String?>(
  (ref, assetId) async {
    try {
      final transactionHistoryN = ref.read(
        operationHistoryNotipod(
          assetId,
        ).notifier,
      );

      await transactionHistoryN.initOperationHistory();
    } catch (_) {
      log('$_');
      ref.read(sNotificationNotipod.notifier).showError(
            'Something went wrong',
            id: 2,
          );
    }
  },
);
