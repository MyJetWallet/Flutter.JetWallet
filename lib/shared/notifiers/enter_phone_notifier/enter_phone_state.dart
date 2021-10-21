import 'package:freezed_annotation/freezed_annotation.dart';

part 'enter_phone_state.freezed.dart';

@freezed
class EnterPhoneState with _$EnterPhoneState {
  const factory EnterPhoneState({
    @Default(false) bool valid,
    @Default('') String? phoneNumber,
  }) = _EnterPhoneState;
}
