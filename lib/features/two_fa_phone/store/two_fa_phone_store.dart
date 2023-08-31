import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_union.dart';
import 'package:jetwallet/utils/helpers/decompose_phone_number.dart';
import 'package:jetwallet/utils/helpers/device_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/fields/standard_field/base/standard_field_error_notifier.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification/phone_verification_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification_verify/phone_verification_verify_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/two_fa_disable/two_fa_disable_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/two_fa_enable/two_fa_enable_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/two_fa_verification/two_fa_verification_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/two_fa_verify/two_fa_verify_request_model.dart';

part 'two_fa_phone_store.g.dart';

class TwoFaPhoneStore extends _TwoFaPhoneStoreBase with _$TwoFaPhoneStore {
  TwoFaPhoneStore(TwoFaPhoneTriggerUnion trigger) : super(trigger);

  static _TwoFaPhoneStoreBase of(BuildContext context) =>
      Provider.of<TwoFaPhoneStore>(context, listen: false);
}

abstract class _TwoFaPhoneStoreBase with Store {
  _TwoFaPhoneStoreBase(this.trigger) {
    _initDefaultState();

    focusNode.addListener(focusListener);
  }

  final TwoFaPhoneTriggerUnion trigger;

  static final _logger = Logger('TwoFaPhoneStore');

  @observable
  FocusNode focusNode = FocusNode();

  @observable
  StackLoaderStore loader = StackLoaderStore();

  StandardFieldErrorNotifier pinError = StandardFieldErrorNotifier();

  @observable
  String phoneNumber = '';

  @observable
  bool showResend = false;

  // If phoneVerified this means that smsVerificationService won't work
  // twoFaService has to be used instead
  @observable
  bool phoneVerified = false;

  @observable
  TwoFaPhoneUnion union = const TwoFaPhoneUnion.input();

  @observable
  TextEditingController controller = TextEditingController();

  @action
  void focusListener() {
    if (focusNode.hasFocus &&
        controller.value.text.length == codeLength &&
        pinError.value) {
      controller.clear();
    }
  }

  @action
  Future<void> _initDefaultState() async {
    await _requestTemplate(
      requestName: 'sessionInfoRequest',
      body: () async {
        //final info = await read(infoServicePod).sessionInfo(intl.localeName);
        final info = await sNetwork.getWalletModule().getSessionInfo();

        info.pick(
          onData: (dataInfo) async {
            final phone = await sNetwork.getValidationModule().getPhoneNumber();

            phone.pick(
              onData: (dataPhone) async {
                _updatePhoneVerified(dataInfo.phoneVerified);
                _updatePhoneNumber(dataPhone.number);

                await sendCode();
              },
            );
          },
        );
      },
    );
  }

  @action
  void _updatePhoneVerified(bool value) {
    phoneVerified = value;
  }

  @action
  void _updatePhoneNumber(String number) {
    phoneNumber = number;
  }

  @action
  void updateShowResend({required bool sResend}) {
    _logger.log(notifier, 'updateShowResend');

    showResend = sResend;
  }

  @action
  Future<void> sendCode() async {
    // In the future there will be other 2FA methods and flow will be changed
    if (phoneVerified) {
      await _sendTwoFaVerificationCode();
    } else {
      await _sendPhoneVerificationCode();
    }
  }

  @action
  Future<void> pasteCode() async {
    _logger.log(notifier, 'pasteCode');

    final data = await Clipboard.getData('text/plain');
    final code = data?.text?.trim() ?? '';

    if (code.length == 4) {
      try {
        int.parse(code);
        controller.text = code;
      } catch (e) {
        return;
      }
    }
  }

  @action
  Future<void> verifyCode() async {
    await trigger.when(
      startup: () => _verifyTwoFa(),
      security: (_) {
        if (phoneVerified) {
          if (sUserInfo.twoFaEnabled) {
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
  @action
  Future<void> _sendTwoFaVerificationCode() async {
    await _requestTemplate(
      requestName: 'sendTwoFaVerificationCode',
      body: () async {
        final model = TwoFaVerificationRequestModel(
          language: intl.localeName,
          deviceType: deviceType,
        );

        await trigger.when(
          startup: () async {
            final _ = await sNetwork
                .getValidationModule()
                .postTwoFaRequestVerification(model);
          },
          security: (_) async {
            if (sUserInfo.twoFaEnabled) {
              final _ = await sNetwork
                  .getValidationModule()
                  .postTwoFaRequestDisable(model);
            } else {
              final _ =
                  sNetwork.getValidationModule().postTwoFaRequestEnable(model);
            }
          },
        );

        union = const TwoFaPhoneUnion.input();
      },
    );
  }

  /// Called at Startup of the app, when we need to verify user
  @action
  Future<void> _verifyTwoFa() async {
    await _requestTemplate(
      requestName: 'verifyTwoFa',
      body: () async {
        final model = TwoFaVerifyRequestModel(
          code: controller.text,
        );

        final response =
            await sNetwork.getValidationModule().postTwoFaVerify(model);

        response.pick(
          onNoData: () {
            getIt.get<StartupService>().processPinState();
          },
          onError: (e) {
            _logger.log(stateFlow, 'verifyCode', e);

            _updateError(Error(e.cause));
          },
        );
      },
    );
  }

  /// Called at Security page, when we need to enable 2fa
  @action
  Future<void> _verifyAndEnableTwoFa() async {
    await _requestTemplate(
      requestName: '_verifyAndEnableTwoFa',
      body: () async {
        final model = TwoFaEnableRequestModel(
          code: controller.text,
        );

        final _ = await sNetwork.getValidationModule().postTwoFaEnable(model);

        sUserInfo.updateTwoFaStatus(enabled: true);

        _returnToPreviousScreen();
      },
    );
  }

  /// Caleed at Security page, when we need to disable 2fa
  @action
  Future<void> _verifyAndDisableTwoFa() async {
    await _requestTemplate(
      requestName: 'verifyAndDisableTwoFa',
      body: () async {
        final model = TwoFaDisableRequestModel(
          code: controller.text,
        );

        final _ = await sNetwork.getValidationModule().postTwoFaDisable(model);

        sUserInfo.updateTwoFaStatus(enabled: false);

        _returnToPreviousScreen();
      },
    );
  }

  /// Will be send at Security page when we are enabling sms auth
  /// if we enabled 2fa from Web
  @action
  Future<void> _sendPhoneVerificationCode() async {
    await _requestTemplate(
      requestName: 'sendCode',
      body: () async {
        final number = await decomposePhoneNumber(
          phoneNumber,
        );

        final model = PhoneVerificationRequestModel(
          locale: intl.localeName,
          phoneBody: number.body,
          phoneCode: '+${number.dialCode}',
          phoneIso: number.isoCode,
          verificationType: 0,
          requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        );

        final _ = await sNetwork
            .getValidationModule()
            .postPhoneVerificationRequest(model);

        union = const TwoFaPhoneUnion.input();
      },
    );
  }

  /// If this method executed without error this means that
  /// 2fa was enabled successfully. Right now we are considering
  /// SMS Authenticator enabled if 2fa is enabled and vice versa.
  /// When we will have more Authenticators this logic will change.
  @action
  Future<void> _verifyPhoneVerificationCode() async {
    await _requestTemplate(
      requestName: 'verifyCode',
      body: () async {
        final number = await decomposePhoneNumber(
          phoneNumber,
        );

        final model = PhoneVerificationVerifyRequestModel(
          code: controller.text,
          phoneBody: number.body,
          phoneCode: '+${number.dialCode}',
          phoneIso: number.isoCode,
        );

        final response = await sNetwork
            .getValidationModule()
            .postPhoneVerificationVerify(model);

        response.pick(
          onData: (data) {},
          onNoData: () {},
          onError: (e) {
            _logger.log(stateFlow, 'verifyCode', e);

            _updateError(Error(e.cause));
          },
        );

        sUserInfo.updatePhoneVerified(phoneVerifiedValue: true);
        sUserInfo.updateTwoFaStatus(enabled: true);

        _returnToPreviousScreen();
      },
    );
  }

  @action
  Future<void> _requestTemplate({
    required String requestName,
    required Future<void> Function() body,
  }) async {
    _logger.log(notifier, requestName);

    union = const TwoFaPhoneUnion.loading();

    try {
      await body();
    } on ServerRejectException catch (e) {
      _logger.log(stateFlow, requestName, e);

      _updateError(Error(e.cause));
    } catch (e) {
      _logger.log(stateFlow, requestName, e);

      _updateError(Error(intl.twoFaPhone_errorOccured));
    }
  }

  /// To avoid snackbar showing for several times instead of one
  /// This happens because of the ProviderListener and because
  /// Error state perssists for several rebuilds
  @action
  void resetError() {
    _logger.log(notifier, 'resetError');

    union = const TwoFaPhoneUnion.input();
  }

  @action
  void _updateError(Error error) {
    union = error;
  }

  @action
  void _returnToPreviousScreen() {
    loader.finishLoading();

    trigger.when(
      startup: () {},
      security: (fromDialog) {
        if (fromDialog) {
          final _context = sRouter.navigatorKey.currentContext!;

          Navigator.of(_context, rootNavigator: true).pop(_context);
        } else {
          sRouter.navigateBack();
        }
      },
    );
  }

  @action
  void dispose() {
    focusNode
      ..removeListener(focusListener)
      ..dispose();
    pinError.dispose();
  }
}
