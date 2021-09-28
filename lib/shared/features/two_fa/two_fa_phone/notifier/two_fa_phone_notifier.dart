import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/sms_verification/model/sms_verification/sms_verification_request.dart';
import '../../../../../service/services/sms_verification/model/sms_verification_verify/sms_verification_verify_request.dart';
import '../../../../../service/services/two_fa/model/two_fa_disable/two_fa_disable_request.dart';
import '../../../../../service/services/two_fa/model/two_fa_enable/two_fa_enable_request.dart';
import '../../../../../service/services/two_fa/model/two_fa_verification/two_fa_verification_request.dart';
import '../../../../../service/services/two_fa/model/two_fa_verify/two_fa_verify_request.dart';
import '../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../helpers/device_type.dart';
import '../../../../logging/levels.dart';
import '../../../../notifiers/user_info_notifier/user_info_notifier.dart';
import '../../../../notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../notifiers/user_info_notifier/user_info_state.dart';
import '../../../../providers/other/navigator_key_pod.dart';
import '../../../../providers/service_providers.dart';
import '../model/two_fa_phone_trigger_union.dart';
import 'two_fa_phone_state.dart';
import 'two_fa_phone_union.dart';

class TwoFaPhoneNotifier extends StateNotifier<TwoFaPhoneState> {
  TwoFaPhoneNotifier(
    this.read,
    this.trigger,
  ) : super(
          TwoFaPhoneState(
            controller: TextEditingController(),
          ),
        ) {
    _initDefaultState();
    _userInfo = read(userInfoNotipod);
    _userInfoN = read(userInfoNotipod.notifier);
    _context = read(navigatorKeyPod).currentContext!;
  }

  final Reader read;
  final TwoFaPhoneTriggerUnion trigger;

  late UserInfoState _userInfo;
  late UserInfoNotifier _userInfoN;
  late BuildContext _context;

  static final _logger = Logger('TwoFaPhoneNotifier');

  Future<void> _initDefaultState() async {
    await _requestTemplate(
      requestName: 'sessionInfoRequest',
      body: () async {
        if (!mounted) return;
        final info = await read(infoServicePod).sessionInfo();

        if (!mounted) return;
        _updatePhoneVerified(info.phoneVerified);

        if (!mounted) return;
        await sendCode();
      },
    );
  }

  void _updatePhoneVerified(bool value) {
    state = state.copyWith(phoneVerified: value);
  }

  void updateShowResend({required bool value}) {
    _logger.log(notifier, 'updateShowResend');

    state = state.copyWith(showResend: value);
  }

  Future<void> sendCode() async {
    // In the future there will be other 2FA methods and flow will be changed
    if (state.phoneVerified) {
      await _sendTwoFaVerificationCode();
    } else {
      await _sendSmsAuthVerificationCode();
    }
  }

  Future<void> verifyCode() async {
    await trigger.when(
      login: () => _verifyTwoFa(),
      security: () {
        if (state.phoneVerified) {
          if (_userInfo.twoFaEnabled) {
            _verifyAndDisableTwoFa();
          } else {
            _verifyAndEnableTwoFa();
          }
        } else {
          _verifyAndEnableSmsAuth();
        }
      },
    );
  }

  /// Will be send at Login page and when we disable 2fa at Security page
  Future<void> _sendTwoFaVerificationCode() async {
    await _requestTemplate(
      requestName: 'sendTwoFaVerificationCode',
      body: () async {
        final model = TwoFaVerificationRequest(
          language: read(intlPod).localeName,
          deviceType: deviceType,
        );

        if (!mounted) return;
        await read(twoFaServicePod).request(model);

        if (!mounted) return;
        state = state.copyWith(union: const Input());
      },
    );
  }

  /// Called at Login page, when we need to verify user
  Future<void> _verifyTwoFa() async {
    await _requestTemplate(
      requestName: 'verifyTwoFa',
      body: () async {
        final model = TwoFaVerifyRequest(
          code: state.controller.text,
        );

        if (!mounted) return;
        await read(twoFaServicePod).verify(model);

        // TODO generalize issue with redirects to the root

        if (!mounted) return;
        state = state.copyWith(union: const Input());
      },
    );
  }

  /// Caleed at Security page, when we need to enable 2fa
  Future<void> _verifyAndEnableTwoFa() async {
    await _requestTemplate(
      requestName: '_verifyAndEnableTwoFa',
      body: () async {
        final model = TwoFaEnableRequest(
          code: state.controller.text,
        );

        if (!mounted) return;
        await read(twoFaServicePod).enable(model);

        if (!mounted) return;
        _userInfoN.updateTwoFaStatus(enabled: true);

        _returnToPreviousScreen();
      },
    );
  }

  /// Caleed at Security page, when we need to disable 2fa
  Future<void> _verifyAndDisableTwoFa() async {
    await _requestTemplate(
      requestName: 'verifyAndDisableTwoFa',
      body: () async {
        final model = TwoFaDisableRequest(
          code: state.controller.text,
        );

        if (!mounted) return;
        await read(twoFaServicePod).disable(model);

        if (!mounted) return;
        _userInfoN.updateTwoFaStatus(enabled: false);

        _returnToPreviousScreen();
      },
    );
  }

  /// Will be send at Security page when we are enabling sms auth
  /// if we enabled 2fa from Web
  Future<void> _sendSmsAuthVerificationCode() async {
    await _requestTemplate(
      requestName: 'sendSmsAuthVerificationCode',
      body: () async {
        final model = SmsVerificationRequest(
          language: read(intlPod).localeName,
          deviceType: deviceType,
        );

        if (!mounted) return;
        await read(smsVerificationServicePod).request(model);

        if (!mounted) return;
        state = state.copyWith(union: const Input());
      },
    );
  }

  /// If this method executed without error this means that
  /// 2fa was enabled successfully. Right now we are considering
  /// SMS Authenticator enabled if 2fa is enabled and vice versa.
  /// When we will have more Authenticators this logic will change.
  Future<void> _verifyAndEnableSmsAuth() async {
    await _requestTemplate(
      requestName: 'verifyAndEnableSmsAuth',
      body: () async {
        final model = SmsVerificationVerifyRequest(
          code: state.controller.text,
        );

        if (!mounted) return;
        await read(smsVerificationServicePod).verify(model);

        if (!mounted) return;
        _userInfoN.updateTwoFaStatus(enabled: true);

        _returnToPreviousScreen();
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

  void _returnToPreviousScreen() {
    Navigator.of(_context, rootNavigator: true).pop(_context);
  }
}
