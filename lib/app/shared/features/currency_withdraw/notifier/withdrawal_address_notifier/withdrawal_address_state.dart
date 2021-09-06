import 'package:freezed_annotation/freezed_annotation.dart';

import 'address_validation_union.dart';

part 'withdrawal_address_state.freezed.dart';

@freezed
class WithdrawalAddressState with _$WithdrawalAddressState {
  const factory WithdrawalAddressState({
    @Default('') String tag,
    @Default('') String address,
    @Default(Invalid()) AddressValidationUnion validation,
  }) = _WithdrawalAddressState;
}
