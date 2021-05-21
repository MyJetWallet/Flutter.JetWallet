import 'package:freezed_annotation/freezed_annotation.dart';

import '../union/withdraw_union.dart';

part 'withdraw_state.freezed.dart';

@freezed
class WithdrawState with _$WithdrawState {
  const factory WithdrawState({
    String? memo,
    required String address,
    required int amount,
    required WithdrawUnion union,
  }) = _WithdrawState;
}
