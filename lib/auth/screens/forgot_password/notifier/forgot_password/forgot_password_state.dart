import 'package:freezed_annotation/freezed_annotation.dart';

import 'forgot_password_union.dart';

part 'forgot_password_state.freezed.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    @Default('') String email,
    @Default(false) bool emailValid,
    @Default(Input()) ForgotPasswordUnion union,
  }) = _ForgotPasswordState;
}
