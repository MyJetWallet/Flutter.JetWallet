import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_by_phone_confirm_state.freezed.dart';

@freezed
class SendByPhoneConfirmState with _$SendByPhoneConfirmState {
  const factory SendByPhoneConfirmState({
    @Default(false) bool isResending,
  }) = _SendByPhoneConfirmState;
}
