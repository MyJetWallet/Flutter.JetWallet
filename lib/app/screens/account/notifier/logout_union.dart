import 'package:freezed_annotation/freezed_annotation.dart';

part 'logout_union.freezed.dart';

@freezed
class LogoutUnion with _$LogoutUnion {
  const factory LogoutUnion.result([
    Object? error,
    StackTrace? stackTrace,
  ]) = Result;
  const factory LogoutUnion.loading() = Loading;
}
