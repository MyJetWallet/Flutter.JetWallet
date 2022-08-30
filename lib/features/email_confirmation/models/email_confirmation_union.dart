import 'package:freezed_annotation/freezed_annotation.dart';

part 'email_confirmation_union.freezed.dart';

@freezed
class EmailConfirmationUnion with _$EmailConfirmationUnion {
  const factory EmailConfirmationUnion.input() = Input;
  const factory EmailConfirmationUnion.error(Object? error) = Error;
  const factory EmailConfirmationUnion.loading() = Loading;
}
