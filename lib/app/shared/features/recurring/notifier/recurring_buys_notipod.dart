import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/recurring_buys_pod.dart';
import 'recurring_buys_notifier.dart';
import 'recurring_buys_state.dart';

final recurringBuysNotipod =
    StateNotifierProvider.autoDispose<RecurringBuysNotifier, RecurringBuysState>(
  (ref) {
    final recurringBuys = ref.watch(recurringBuysPod);

    return RecurringBuysNotifier(
      ref.read,
      recurringBuys,
    );
  },
);
