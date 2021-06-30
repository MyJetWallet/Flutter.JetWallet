import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_verification_union.freezed.dart';

@freezed
class EmailVerificationUnion with _$EmailVerificationUnion {
  const factory EmailVerificationUnion.input() = Input;
  const factory EmailVerificationUnion.error(Object? error) = Error;
  const factory EmailVerificationUnion.loading() = Loading;
}
