import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_password_union.freezed.dart';

@freezed
class ResetPasswordUnion with _$ResetPasswordUnion {
  const factory ResetPasswordUnion.input([
    Object? error,
    StackTrace? stackTrace,
  ]) = Input;
  const factory ResetPasswordUnion.loading() = Loading;
}
