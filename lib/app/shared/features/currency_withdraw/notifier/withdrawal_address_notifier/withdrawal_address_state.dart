import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'address_validation_union.dart';

part 'withdrawal_address_state.freezed.dart';

@freezed
class WithdrawalAddressState with _$WithdrawalAddressState {
  const factory WithdrawalAddressState({
    QRViewController? qrController,
    @Default('') String tag,
    @Default('') String address,
    @Default(Invalid()) AddressValidationUnion validation,
    required TextEditingController addressController,
    required TextEditingController tagController,
    required FocusNode addressFocus,
    required FocusNode tagFocus,
    required Key qrKey,
  }) = _WithdrawalAddressState;

  const WithdrawalAddressState._();

  bool get showAddressErase => addressFocus.hasFocus && address.isNotEmpty;
  bool get showAddressEmptyField => addressFocus.hasFocus && address.isEmpty;
  bool get showTagErase => tagFocus.hasFocus && tag.isNotEmpty;
  bool get showTagEmptyField => tagFocus.hasFocus && tag.isEmpty;
}
