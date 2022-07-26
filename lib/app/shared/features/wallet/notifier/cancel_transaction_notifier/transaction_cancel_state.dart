import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_cancel_state.freezed.dart';

@freezed
class TransactionCancelState with _$TransactionCancelState {
  const factory TransactionCancelState({
    @Default(false) bool loading,
  }) = _TransactionCancelState;
}
