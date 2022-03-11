import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_password_reset_union.freezed.dart';

@freezed
class ConfirmPasswordResetUnion with _$ConfirmPasswordResetUnion {
  const factory ConfirmPasswordResetUnion.input() = Input;
  const factory ConfirmPasswordResetUnion.error(Object? error) = Error;
  const factory ConfirmPasswordResetUnion.loading() = Loading;
}
