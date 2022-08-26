import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_info_state.freezed.dart';

@freezed
class AuthInfoState with _$AuthInfoState {
  const factory AuthInfoState({
    @Default('') String token,
    @Default('') String refreshToken,
    @Default('') String email,
    @Default('') String deleteToken,
    @Default('') String verificationToken,
    @Default(true) bool showResendButton,
  }) = _AuthInfoState;
}
