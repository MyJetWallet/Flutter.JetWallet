import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import 'operation_history_union.dart';

part 'operation_history_state.freezed.dart';

@freezed
class OperationHistoryState with _$OperationHistoryState {
  const factory OperationHistoryState({
    required List<OperationHistoryItem> operationHistoryItems,
    @Default(Loading()) OperationHistoryUnion union,
    @Default(false) bool nothingToLoad,
  }) = _OperationHistoryState;
}
