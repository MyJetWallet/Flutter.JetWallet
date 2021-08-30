import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_deposit_union.freezed.dart';

@freezed
class CurrencyDepositUnion with _$CurrencyDepositUnion{
  const factory CurrencyDepositUnion.success() = Success;
  const factory CurrencyDepositUnion.loading() = Loading;
}
