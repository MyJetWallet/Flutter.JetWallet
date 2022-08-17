import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_union.freezed.dart';

@freezed
class ResetPasswordUnion with _$ResetPasswordUnion {
  const factory ResetPasswordUnion.input() = Input;
  const factory ResetPasswordUnion.error(Object error) = Error;
  const factory ResetPasswordUnion.loading() = Loading;
}
