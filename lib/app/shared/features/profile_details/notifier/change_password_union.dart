import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_union.freezed.dart';

@freezed
class ChangePasswordUnion with _$ChangePasswordUnion {
  const factory ChangePasswordUnion.input() = Input;
  const factory ChangePasswordUnion.error(Object error) = Error;
  const factory ChangePasswordUnion.done() = Done;
}
