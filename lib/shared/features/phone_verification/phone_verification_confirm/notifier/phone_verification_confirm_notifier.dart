import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/phone_verification/model/phone_verification/phone_verification_request_model.dart';
import '../../../../../service/services/phone_verification/model/phone_verification_verify/phone_verification_verify_request_model.dart';
import '../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../logging/levels.dart';
import '../../../../notifiers/phone_number_notifier/phone_number_notifier.dart';
import '../../../../notifiers/phone_number_notifier/phone_number_notipod.dart';
import '../../../../notifiers/user_info_notifier/user_info_notifier.dart';
import '../../../../notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../providers/service_providers.dart';
import 'phone_verification_confirm_state.dart';
import 'phone_verification_confirm_union.dart';

class PhoneVerificationConfirmNotifier
    extends StateNotifier<PhoneVerificationConfirmState> {
  PhoneVerificationConfirmNotifier(
    this.read,
    this.onVerified,
  ) : super(
          PhoneVerificationConfirmState(
            controller: TextEditingController(),
          ),
        ) {
    _userInfoN = read(userInfoNotipod.notifier);
    _phoneNumberN = read(phoneNumberNotipod.notifier);

    final countryPhoneVerification = read(phoneNumberNotipod);

    final phoneNumberWithIso =
        '${countryPhoneVerification.countryCode}'
    '${countryPhoneVerification.phoneNumber}';

    _updatePhoneNumber(phoneNumberWithIso);
    sendCode();
  }

  final Reader read;
  final Function() onVerified;

  late UserInfoNotifier _userInfoN;
  late PhoneNumberNotifier _phoneNumberN;

  static final _logger = Logger('PhoneVerificationConfirmNotifier');

  void updateShowResend({required bool showResend}) {
    _logger.log(notifier, 'updateShowResend');

    state = state.copyWith(showResend: showResend);
  }

  Future<void> sendCode() async {
    _logger.log(notifier, 'sendCode');

    await _requestTemplate(
      requestName: 'sendCode',
      body: () async {
        final model = PhoneVerificationRequestModel(
          language: read(intlPod).localeName,
          phoneNumber: state.phoneNumber,
        );

        await read(phoneVerificationServicePod).request(model);
        state = state.copyWith(union: const Input());
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
          phoneNumber: state.phoneNumber,
        );

        await read(phoneVerificationServicePod).verify(model);

        _userInfoN.updatePhoneVerified(phoneVerified: true);
        _userInfoN.updateTwoFaStatus(enabled: true);
        _userInfoN.updatePhone(state.phoneNumber);
        _phoneNumberN.updatePhoneNumber('');
        if (!mounted) return;
        onVerified();
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

      _updateError(Error(e.cause));
    } catch (e) {
      _logger.log(stateFlow, requestName, e);

      _updateError(const Error('Error occured'));
    }
  }

  /// To avoid snackbar showing for several times instead of one
  /// This happens because of the ProviderListener and because
  /// Error state perssists for several rebuilds
  void resetError() {
    _logger.log(notifier, 'resetError');

    state = state.copyWith(union: const Input());
  }

  void _updateError(Error error) {
    state = state.copyWith(union: error);
  }

  void _updatePhoneNumber(String? number) {
    state = state.copyWith(phoneNumber: number ?? '');
  }
}
