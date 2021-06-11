import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdraw_union.freezed.dart';

@freezed
class WithdrawUnion with _$WithdrawUnion {
  const factory WithdrawUnion.input([
    Object? error,
    StackTrace? stackTrace,
  ]) = Input;
  const factory WithdrawUnion.loading() = Loading;
}
