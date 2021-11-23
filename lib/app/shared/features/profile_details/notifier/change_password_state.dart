import 'package:freezed_annotation/freezed_annotation.dart';
import 'change_password_union.dart';

part 'change_password_state.freezed.dart';

@freezed
class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    String? oldPassword,
    String? newPassword,
    @Default(false) bool oldPasswordValid,
    @Default(Input()) ChangePasswordUnion union,
  }) = _ChangePasswordState;
}
