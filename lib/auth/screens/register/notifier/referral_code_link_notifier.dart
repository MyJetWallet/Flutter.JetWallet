import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../service/services/referral_code_service/model/validate_referral_code_request_model.dart';
import '../../../../shared/logging/levels.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/local_storage_service.dart';
import 'referral_code_link_state.dart';
import 'referral_code_link_union.dart';

enum CameraStatus { permanentlyDenied, denied, granted }

/// Responsible for input and validation of withdrawal address and tag
class ReferralCodeLinkNotifier extends StateNotifier<ReferralCodeLinkState> {
  ReferralCodeLinkNotifier({
    required this.read,
  }) : super(
          ReferralCodeLinkState(
            referralCodeController: TextEditingController(),
            referralCodeErrorNotifier: StandardFieldErrorNotifier(),
          ),
        ) {
    _init();
  }

  final Reader read;

  static final _logger = Logger('ReferralCodeLinkNotifier');

  Future<void> _init() async {
    final storage = read(localStorageServicePod);
    await storage.clearStorage();
    final referralCode = await storage.getString(referralCodeKey);

    if (referralCode != null) {
      state = state.copyWith(
        referralCode: referralCode,
        referralCodeValidation: const Loading(),
      );

      await validateReferralCode(referralCode);
    }
  }

  Future<void> validateReferralCode(String code) async {
    state = state.copyWith(
      referralCodeValidation: const Loading(),
      bottomSheetReferralCodeValidation: const Loading(),
    );
    try {
      final model = ValidateReferralCodeRequestModel(
        referralCode: code,
      );

      final service = read(referralCodeServicePod);

      await service.validateReferralCode(model);

      if (!mounted) return;

      state = state.copyWith(
        referralCodeValidation: const Valid(),
        bottomSheetReferralCodeValidation: const Valid(),
        referralCode: code,
      );
    } catch (error) {
      if (!mounted) return;

      _logger.log(stateFlow, 'validateReferralCode', error);

      state = state.copyWith(
        referralCodeValidation: const Invalid(),
        bottomSheetReferralCodeValidation: const Invalid(),
      );

      _triggerErrorOfReferralCodeField();
    }
  }

  void updateReferralCode(String code) {
    state = state.copyWith(bottomSheetReferralCode: code);
  }

  void resetBottomSheetReferralCodeValidation() {
    state = state.copyWith(
      bottomSheetReferralCodeValidation: const Input(),
      bottomSheetReferralCode: null,
      referralCodeController: TextEditingController(),
      referralCodeErrorNotifier: StandardFieldErrorNotifier(),
    );
  }

  Future<void> pasteCodeReferralLink() async {
    _logger.log(notifier, 'pasteCodeReferralLink');

    final copiedText = await _copiedText();
    state.referralCodeController.text = copiedText;
    _moveCursorAtTheEnd(state.referralCodeController);
    state = state.copyWith(bottomSheetReferralCode: copiedText);
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');
    return (data?.text ?? '').replaceAll(' ', '');
  }

  void _triggerErrorOfReferralCodeField() {
    state.referralCodeErrorNotifier!.enableError();
  }

  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}
