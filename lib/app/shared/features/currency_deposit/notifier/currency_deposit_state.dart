import 'package:freezed_annotation/freezed_annotation.dart';

import 'currency_deposit_union.dart';

part 'currency_deposit_state.freezed.dart';

@freezed
class CurrencyDepositState with _$CurrencyDepositState {
  const factory CurrencyDepositState({
    String? tag,
    @Default(true) bool openAddress,
    @Default(false) bool openTag,
    @Default('') String address,
    @Default(Loading()) CurrencyDepositUnion union,
  }) = _CurrencyDepositState;
}
