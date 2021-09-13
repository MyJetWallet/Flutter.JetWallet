import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_preview_state.freezed.dart';

@freezed
class WithdrawalPreviewState with _$WithdrawalPreviewState {
  const factory WithdrawalPreviewState({
    @Default('') String tag,
    @Default('') String address,
    @Default('0') String amount,
    @Default('') String operationId,
    @Default(false) bool loading,
    @Default(false) bool addressIsInternal,
  }) = _WithdrawalPreviewState;
}
