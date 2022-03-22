import 'package:freezed_annotation/freezed_annotation.dart';

part 'forgot_password_union.freezed.dart';

@freezed
class ForgotPasswordUnion with _$ForgotPasswordUnion {
  const factory ForgotPasswordUnion.input() = Input;
  const factory ForgotPasswordUnion.error(Object error) = Error;
  const factory ForgotPasswordUnion.loading() = Loading;
}
