import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../../../auth/shared/helpers/password_validators.dart';
import 'change_password_union.dart';

part 'change_password_state.freezed.dart';

@freezed
class ChangePasswordState with _$ChangePasswordState {
  const factory ChangePasswordState({
    @Default('') String oldPassword,
    @Default('') String newPassword,
    @Default(false) bool oldPasswordValid,
    @Default(Input()) ChangePasswordUnion union,
  }) = _ChangePasswordState;

  const ChangePasswordState._();

  bool get isButtonActive {
    return oldPassword.isNotEmpty;
  }

  bool get isNewPasswordButtonActive {
    return isPasswordValid(newPassword);
  }
}
