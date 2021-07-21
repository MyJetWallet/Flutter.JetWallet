import 'package:freezed_annotation/freezed_annotation.dart';

import 'reset_password_union.dart';

part 'reset_password_state.freezed.dart';

@freezed
class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState({
    @Default('') String password,
    @Default(false) bool passwordValid,
    @Default(Input()) ResetPasswordUnion union,
  }) = _ResetPasswordState;
}
