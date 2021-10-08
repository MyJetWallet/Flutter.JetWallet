import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_preview_state.freezed.dart';

@freezed
class SendPreviewState with _$SendPreviewState {
  const factory SendPreviewState({
    @Default('') String phoneNumber,
    @Default('0') String amount,
    @Default('') String operationId,
    @Default(false) bool loading,
    @Default(false) bool receiverIsRegistered,
  }) = _SendPreviewState;
}
