import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:simple_kit/simple_kit.dart';

import 'referral_code_link_union.dart';

part 'referral_code_link_state.freezed.dart';

@freezed
class ReferralCodeLinkState with _$ReferralCodeLinkState {
  const factory ReferralCodeLinkState({
    String? referralCode,
    String? bottomSheetReferralCode,
    QRViewController? qrController,
    StandardFieldErrorNotifier? referralCodeErrorNotifier,
    @Default(Input()) ReferralCodeLinkUnion referralCodeValidation,
    @Default(Input()) ReferralCodeLinkUnion bottomSheetReferralCodeValidation,
    @Default(0) int timer,
    required TextEditingController referralCodeController,
    required Key qrKey,
  }) = _ReferralCodeLinkState;

  const ReferralCodeLinkState._();

  bool get enableContinueButton {
    return bottomSheetReferralCodeValidation is Valid;
  }
}
