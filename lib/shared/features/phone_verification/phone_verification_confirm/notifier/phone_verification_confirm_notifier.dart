import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/phone_verification/model/phone_verification/phone_verification_request_model.dart';
import '../../../../../service/services/phone_verification/model/phone_verification_verify/phone_verification_verify_request_model.dart';
import '../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../logging/levels.dart';
import '../../../../notifiers/user_info_notifier/user_info_notifier.dart';
import '../../../../notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../providers/other/navigator_key_pod.dart';
import '../../../../providers/service_providers.dart';
import '../../phone_verification_enter/notifier/phone_verification_enter_notipod.dart';
import 'phone_verification_confirm_state.dart';
import 'phone_verification_confirm_union.dart';

class PhoneVerificationConfirmNotifier
    extends StateNotifier<PhoneVerificationConfirmState> {
  PhoneVerificationConfirmNotifier(
    this.read,
  ) : super(
          PhoneVerificationConfirmState(
            controller: TextEditingController(),
          ),
        ) {
    final phoneVerification = read(phoneVerificationEnterNotipod);
    _updatePhoneNumber(phoneVerification.phoneNumber);
    sendCode();
    _userInfoN = read(userInfoNotipod.notifier);
    _context = read(navigatorKeyPod).currentContext!;
  }

  final Reader read;

  late UserInfoNotifier _userInfoN;
  late BuildContext _context;

  static final _logger = Logger('PhoneVerificationConfirmNotifier');

  void updateShowResend({required bool showResend}) {
    _logger.log(notifier, 'updateShowResend');

    state = state.copyWith(showResend: showResend);
  }

  Future<void> sendCode() async {
    await _requestTemplate(
      requestName: 'sendCode',
      body: () async {
        final model = PhoneVerificationRequestModel(
          language: read(intlPod).localeName,
          phoneNumber: state.phoneNumber,
        );

        await read(phoneVerificationServicePod).request(model);

        if (!mounted) return;
        state = state.copyWith(union: const Input());
      },
    );
  }

  Future<void> verifyCode() async {
    await _requestTemplate(
      requestName: 'verifyCode',
      body: () async {
        final model = PhoneVerificationVerifyRequestModel(
          code: state.controller.text,
        );

        await read(phoneVerificationServicePod).verify(model);

        _userInfoN.updatePhoneVerified(phoneVerified: true);
        _userInfoN.updateTwoFaStatus(enabled: true);

        if (!mounted) return;
        Navigator.pop(_context);
        Navigator.pop(_context);
      },
    );
  }

  Future<void> _requestTemplate({
    required String requestName,
    required Future<void> Function() body,
  }) async {
    _logger.log(notifier, requestName);

    state = state.copyWith(union: const Loading());

    try {
      await body();
    } on ServerRejectException catch (e) {
      _logger.log(stateFlow, requestName, e);

      state = state.copyWith(union: Error(e.cause));
    } catch (e) {
      _logger.log(stateFlow, requestName, e);

      state = state.copyWith(
        union: const Error('Error occured'),
      );
    }
  }

  void _updatePhoneNumber(String? number) {
    state = state.copyWith(phoneNumber: number ?? '');
  }
}
