import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../models/recurring_buys_model.dart';

part 'recurring_buys_state.freezed.dart';

@freezed
class RecurringBuysState with _$RecurringBuysState {
  const factory RecurringBuysState({
    String? recurringTotal,
    required List<RecurringBuysModel> recurringBuys,
  }) = _RecurringBuysState;
}
