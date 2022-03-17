import 'package:freezed_annotation/freezed_annotation.dart';

part 'withdrawal_confirm_union.freezed.dart';

@freezed
class WithdrawalConfirmUnion with _$WithdrawalConfirmUnion {
  const factory WithdrawalConfirmUnion.input() = Input;
  const factory WithdrawalConfirmUnion.error(Object? error) = Error;
  const factory WithdrawalConfirmUnion.loading() = Loading;
}
