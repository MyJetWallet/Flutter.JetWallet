import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info_state.freezed.dart';

@freezed
class UserInfoState with _$UserInfoState {
  const factory UserInfoState({
    String? pin,
    /// If after reister/login user disabled a pin.
    /// If pin is disabled manually we don't ask 
    /// to set pin again (in authorized state)
    /// After logout this will be reseted
    @Default(false) bool pinDisabled,
    @Default(false) bool twoFaEnabled,
    @Default(false) bool phoneVerified,
  }) = _UserInfoState;

  const UserInfoState._();

  bool get pinEnabled => pin != null;
}
