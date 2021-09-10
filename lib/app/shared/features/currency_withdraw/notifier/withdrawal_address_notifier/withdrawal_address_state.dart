import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../models/currency_model.dart';
import 'address_validation_union.dart';

part 'withdrawal_address_state.freezed.dart';

@freezed
class WithdrawalAddressState with _$WithdrawalAddressState {
  const factory WithdrawalAddressState({
    QRViewController? qrController,
    @Default(false) bool addressIsInternal,
    @Default('') String tag,
    @Default('') String address,
    @Default(Hide()) AddressValidationUnion addressValidation,
    @Default(Hide()) AddressValidationUnion tagValidation,
    required TextEditingController addressController,
    required TextEditingController tagController,
    required FocusNode addressFocus,
    required FocusNode tagFocus,
    required Key qrKey,
  }) = _WithdrawalAddressState;

  const WithdrawalAddressState._();

  bool get showAddressErase => address.isNotEmpty;
  bool get showTagErase => tag.isNotEmpty;

  bool credentialsValid(CurrencyModel currency) {
    if (currency.hasTag) {
      return addressValidation is Valid && tagValidation is Valid;
    } else {
      return addressValidation is Valid;
    }
  }

  bool inputIsNotEmpty(CurrencyModel currency) {
    if (currency.hasTag) {
      return address.isNotEmpty && tag.isNotEmpty;
    } else {
      return address.isNotEmpty;
    }
  }
}
