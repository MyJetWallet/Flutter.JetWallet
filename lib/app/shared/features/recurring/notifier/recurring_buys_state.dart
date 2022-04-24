import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../service/services/signal_r/model/recurring_buys_model.dart';
import '../helper/recurring_buys_status_name.dart';

part 'recurring_buys_state.freezed.dart';

@freezed
class RecurringBuysState with _$RecurringBuysState {
  const factory RecurringBuysState({
    String? recurringTotal,
    required List<RecurringBuysModel> recurringBuys,
  }) = _RecurringBuysState;

  const RecurringBuysState._();

  RecurringBuysStatus get recurringBuysStatus {
    if (recurringBuys.isNotEmpty) {
      final active = recurringBuys.where(
        (element) =>
            element.status == RecurringBuysStatus.active ||
            element.status == RecurringBuysStatus.paused,
      );
      if (active.isNotEmpty) {
        return RecurringBuysStatus.active;
      }
    }

    return RecurringBuysStatus.empty;
  }

  RecurringBuysStatus get typeActiveOrEmpty {
    if (recurringBuys.isNotEmpty) {
      final activeRecurringBuysList = recurringBuys
          .where((element) => element.status == RecurringBuysStatus.active);

      if (activeRecurringBuysList.isNotEmpty) {
        return RecurringBuysStatus.active;
      }
    }

    return RecurringBuysStatus.empty;
  }

  bool get recurringPausedNavigateToHistory {
    if (recurringBuys.isNotEmpty) {
      final pausedRecurringBuysList = recurringBuys
          .where((element) => element.status == RecurringBuysStatus.paused);

      if (pausedRecurringBuysList.isNotEmpty &&
          pausedRecurringBuysList.length == recurringBuys.length &&
          recurringBuys.length > 1) {
        return true;
      }
    }

    return false;
  }
}
