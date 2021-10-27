import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../auth/screens/splash/notifier/startup_notifier/startup_notipod.dart';
import '../../../../../service/services/phone_verification/model/phone_verification/phone_verification_request_model.dart';
import '../../../../../service/services/phone_verification/model/phone_verification_verify/phone_verification_verify_request_model.dart';
import '../../../../../service/services/two_fa/model/two_fa_disable/two_fa_disable_request_model.dart';
import '../../../../../service/services/two_fa/model/two_fa_enable/two_fa_enable_request_model.dart';
import '../../../../../service/services/two_fa/model/two_fa_verification/two_fa_verification_request_model.dart';
import '../../../../../service/services/two_fa/model/two_fa_verify/two_fa_verify_request_model.dart';
import '../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../helpers/device_type.dart';
import '../../../../logging/levels.dart';
import '../../../../notifiers/user_info_notifier/user_info_notifier.dart';
import '../../../../notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../notifiers/user_info_notifier/user_info_state.dart';
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
    _context = read(sNavigatorKeyPod).currentContext!;
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
        final info = await read(infoServicePod).sessionInfo();
        final phone = await read(phoneVerificationServicePod).phoneNumber();

        if (!mounted) return;
        _updatePhoneVerified(info.phoneVerified);
        _updatePhoneNumber(phone.number);

        await sendCode();
      },
    );
  }

  void _updatePhoneVerified(bool value) {
    state = state.copyWith(phoneVerified: value);
  }

  void _updatePhoneNumber(String number) {
    state = state.copyWith(phoneNumber: number);
  }

  void updateShowResend({required bool showResend}) {
    _logger.log(notifier, 'updateShowResend');

    state = state.copyWith(showResend: showResend);
  }

  Future<void> sendCode() async {
    // In the future there will be other 2FA methods and flow will be changed
    if (state.phoneVerified) {
      await _sendTwoFaVerificationCode();
    } else {
      await _sendPhoneVerificationCode();
    }
  }

  Future<void> verifyCode() async {
    await trigger.when(
      startup: () => _verifyTwoFa(),
      security: (_) {
        if (state.phoneVerified) {
          if (_userInfo.twoFaEnabled) {
            _verifyAndDisableTwoFa();
          } else {
            _verifyAndEnableTwoFa();
          }
        } else {
          _verifyPhoneVerificationCode();
        }
      },
    );
  }

  /// Will be send at Startup of the app,
  /// and when we enable/disable 2fa at Security page
  Future<void> _sendTwoFaVerificationCode() async {
    await _requestTemplate(
      requestName: 'sendTwoFaVerificationCode',
      body: () async {
        final model = TwoFaVerificationRequestModel(
          language: read(intlPod).localeName,
          deviceType: deviceType,
        );

        await trigger.when(
          startup: () async {
            await read(twoFaServicePod).requestVerification(model);
          },
          security: (_) async {
            if (_userInfo.twoFaEnabled) {
              await read(twoFaServicePod).requestDisable(model);
            } else {
              await read(twoFaServicePod).requestEnable(model);
            }
          },
        );

        if (!mounted) return;
        state = state.copyWith(union: const Input());
      },
    );
  }

  /// Called at Startup of the app, when we need to verify user
  Future<void> _verifyTwoFa() async {
    await _requestTemplate(
      requestName: 'verifyTwoFa',
      body: () async {
        final model = TwoFaVerifyRequestModel(
          code: state.controller.text,
        );

        await read(twoFaServicePod).verify(model);

        read(startupNotipod.notifier).twoFaVerified();
      },
    );
  }

  /// Called at Security page, when we need to enable 2fa
  Future<void> _verifyAndEnableTwoFa() async {
    await _requestTemplate(
      requestName: '_verifyAndEnableTwoFa',
      body: () async {
        final model = TwoFaEnableRequestModel(
          code: state.controller.text,
        );

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
        final model = TwoFaDisableRequestModel(
          code: state.controller.text,
        );

        await read(twoFaServicePod).disable(model);

        if (!mounted) return;
        _userInfoN.updateTwoFaStatus(enabled: false);

        _returnToPreviousScreen();
      },
    );
  }

  /// Will be send at Security page when we are enabling sms auth
  /// if we enabled 2fa from Web
  Future<void> _sendPhoneVerificationCode() async {
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

  /// If this method executed without error this means that
  /// 2fa was enabled successfully. Right now we are considering
  /// SMS Authenticator enabled if 2fa is enabled and vice versa.
  /// When we will have more Authenticators this logic will change.
  Future<void> _verifyPhoneVerificationCode() async {
    await _requestTemplate(
      requestName: 'verifyCode',
      body: () async {
        final model = PhoneVerificationVerifyRequestModel(
          code: state.controller.text,
          phoneNumber: state.phoneNumber,
        );

        await read(phoneVerificationServicePod).verify(model);

        if (!mounted) return;

        _userInfoN.updatePhoneVerified(phoneVerified: true);
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

  void _returnToPreviousScreen() {
    trigger.when(
      startup: () {},
      security: (fromDialog) {
        if (fromDialog) {
          Navigator.of(_context, rootNavigator: true).pop(_context);
        } else {
          Navigator.pop(_context);
        }
      },
    );
  }
}
