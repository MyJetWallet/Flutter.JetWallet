import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'transaction_cancel_notifier.dart';
import 'transaction_cancel_state.dart';

final transferCancelNotipod = StateNotifierProvider.autoDispose<
    TransactionCancelNotifier, TransactionCancelState>(
  (ref) {
    return TransactionCancelNotifier(ref.read);
  },
  name: 'transactionCancelNotipod',
);
