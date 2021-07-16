import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_union.freezed.dart';

@freezed
class AuthenticationUnion with _$AuthenticationUnion {
  const factory AuthenticationUnion.input([
    Object? error,
    StackTrace? stackTrace,
  ]) = Input;
  const factory AuthenticationUnion.loading() = Loading;
}
