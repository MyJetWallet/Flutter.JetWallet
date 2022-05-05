import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/blockchains_model.dart';

import '../../../../models/currency_model.dart';
import 'address_validation_union.dart';

part 'withdrawal_address_state.freezed.dart';

@freezed
class WithdrawalAddressState with _$WithdrawalAddressState {
  const factory WithdrawalAddressState({
    CurrencyModel? currency,
    QRViewController? qrController,
    StandardFieldErrorNotifier? addressErrorNotifier,
    StandardFieldErrorNotifier? tagErrorNotifier,
    @Default(false) bool addressIsInternal,
    @Default('') String tag,
    @Default('') String address,
    @Default(BlockchainModel()) BlockchainModel network,
    @Default(Hide()) AddressValidationUnion addressValidation,
    @Default(Hide()) AddressValidationUnion tagValidation,
    required TextEditingController networkController,
    required TextEditingController addressController,
    required TextEditingController tagController,
    required FocusNode addressFocus,
    required FocusNode tagFocus,
    required Key qrKey,
  }) = _WithdrawalAddressState;

  const WithdrawalAddressState._();

  bool get showAddressErase => address.isNotEmpty;
  bool get showTagErase => tag.isNotEmpty;

  bool get credentialsValid {
    if (currency!.hasTag) {
      return addressValidation is Valid && tagValidation is Valid;
    } else {
      return addressValidation is Valid;
    }
  }

  bool get isReadyToContinue {
    final condition1 = addressValidation is Hide || addressValidation is Valid;
    final condition2 = tagValidation is Hide || tagValidation is Valid;
    final condition3 = address.isNotEmpty;
    final condition4 = tag.isNotEmpty;

    if (currency!.hasTag) {
      return condition1 && condition2 && condition3 && condition4;
    } else {
      return condition1 && condition3;
    }
  }

  bool get requirementLoading {
    if (currency!.hasTag) {
      return addressValidation is Loading || tagValidation is Loading;
    } else {
      return addressValidation is Loading;
    }
  }

  bool get isRequirementError {
    if (currency!.hasTag) {
      return addressValidation is Invalid || tagValidation is Invalid;
    } else {
      return addressValidation is Invalid;
    }
  }

  String get validationResult {
    if (addressValidation is Loading || tagValidation is Loading) {
      return 'Checking...';
    } else if (addressValidation is Invalid) {
      return 'Invalid ${currency!.symbol} Address';
    } else if (tagValidation is Invalid) {
      return 'Invalid ${currency!.symbol} Tag';
    } else if (addressValidation is Invalid && tagValidation is Invalid) {
      return 'Invalid ${currency!.symbol} Address & Tag';
    } else if (addressValidation is Valid && tagValidation is Valid) {
      return 'Valid ${currency!.symbol} Address & Tag';
    } else if (addressValidation is Valid) {
      return 'Valid ${currency!.symbol} Address';
    } else if (tagValidation is Valid) {
      return 'Valid ${currency!.symbol} Tag';
    } else {
      return 'Error';
    }
  }

  String get withdrawHint {
    if (isReadyToContinue) {
      return 'Please confirm the address is correct. Note that we are '
          'not responsible for assets mistakenly sent to the wrong address.';
    } else {
      return 'Instead of typing in an address and tag, we recommend pasting '
          'an address or scanning a QR code.';
    }
  }
}
