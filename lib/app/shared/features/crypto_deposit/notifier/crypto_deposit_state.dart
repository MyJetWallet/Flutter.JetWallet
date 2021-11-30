import 'package:freezed_annotation/freezed_annotation.dart';

import 'crypto_deposit_union.dart';

part 'crypto_deposit_state.freezed.dart';

@freezed
class CryptoDepositState with _$CryptoDepositState {
  const factory CryptoDepositState({
    String? tag,
    @Default(true) bool openAddress,
    @Default(false) bool openTag,
    @Default('') String address,
    @Default(Loading()) CryptoDepositUnion union,
  }) = _CryptoDepositState;
}
