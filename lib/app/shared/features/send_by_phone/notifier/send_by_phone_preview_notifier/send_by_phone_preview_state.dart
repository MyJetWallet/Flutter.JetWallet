import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_by_phone_preview_state.freezed.dart';

@freezed
class SendByPhonePreviewState with _$SendByPhonePreviewState {
  const factory SendByPhonePreviewState({
    @Default('0') String amount,
    @Default('') String operationId,
    @Default(false) bool loading,
  }) = _SendByPhonePreviewState;
}
