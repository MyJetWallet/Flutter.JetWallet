import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

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
    }
  }

  void updateReferralCode(String code) {
    state = state.copyWith(bottomSheetReferralCode: code);
  }

  void resetBottomSheetReferralCodeValidation() {
    state = state.copyWith(
      bottomSheetReferralCodeValidation: const Input(),
      bottomSheetReferralCode: null,
    );
  }
}
