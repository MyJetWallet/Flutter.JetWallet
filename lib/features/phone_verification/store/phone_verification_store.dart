import 'dart:async';

import 'package:data_channel/data_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:jetwallet/utils/helpers/decompose_phone_number.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/account/phone_number/simple_number.dart';
import 'package:simple_kit/modules/fields/standard_field/base/standard_field_error_notifier.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/models/device_binding/post_device_binding_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/device_binding/post_device_binding_verify_model.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification/phone_verification_full_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification/phone_verification_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification_verify/phone_verification_full_verify_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification_verify/phone_verification_verify_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/transfer_verification/transfer_resend_code_request_model.dart';
import 'package:simple_networking/modules/validation_api/models/transfer_verification/transfer_verify_code_request_model.dart';

part 'phone_verification_store.g.dart';

class PhoneVerificationStore extends _PhoneVerificationStoreBase with _$PhoneVerificationStore {
  PhoneVerificationStore(super.args);

  static _PhoneVerificationStoreBase of(BuildContext context) =>
      Provider.of<PhoneVerificationStore>(context, listen: false);
}

abstract class _PhoneVerificationStoreBase with Store {
  _PhoneVerificationStoreBase(this.args) {
    _initState();
    refreshTimer();
  }

  final PhoneVerificationArgs args;

  static final _logger = Logger('PhoneVerificationStore');

  StackLoaderStore loader = StackLoaderStore();

  StandardFieldErrorNotifier pinFieldError = StandardFieldErrorNotifier();

  FocusNode focusNode = FocusNode();

  @observable
  String phoneNumber = '';

  @observable
  SPhoneNumber? dialCode;

  @observable
  bool showResend = false;

  @observable
  bool resendTapped = false;

  TextEditingController controller = TextEditingController();

  @observable
  int time = 0;

  @observable
  Timer? _timer;

  @action
  void refreshTimer() {
    _timer?.cancel();

    time = args.isUnlimitTransferConfirm ? 180 : 30;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        time = time - 1;
      },
    );
  }

  @action
  void _initState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      focusNode.requestFocus();
    });

    _updatePhoneNumber(args.phoneNumber);
    _updateDialCode(args.activeDialCode);
    if (args.sendCodeOnInitState) {
      sendFullCode(true);
    }
  }

  @action
  void updateShowResend({required bool sResend}) {
    _logger.log(notifier, 'updateShowResend');

    showResend = sResend;
  }

  @action
  Future<void> sendCode(bool isStart) async {
    try {
      resendTapped = true;
      late DC<ServerRejectException, void> response;
      if (args.isDeviceBinding) {
        final model = PostDeviceBindingRequestModel(
          locale: intl.localeName,
          verificationType: isStart ? 1 : 2,
          requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        );

        response = await sNetwork.getValidationModule().postDeviceBindingRequest(model);
      } else if (args.isUnlimitTransferConfirm) {
        final model = TransferResendCodeRequestModel(
          transactionId: args.transactionId ?? '',
        );

        response = await sNetwork.getValidationModule().postTransferResendCode(model);
      } else {
        final number = await decomposePhoneNumber(
          phoneNumber,
          isoCodeNumber: dialCode?.isoCode ?? '',
        );

        final model = PhoneVerificationRequestModel(
          locale: intl.localeName,
          phoneBody: number.body.replaceAll(
            dialCode?.countryCode ?? '',
            '',
          ),
          phoneCode: dialCode?.countryCode ?? '',
          phoneIso: number.isoCode,
          verificationType: isStart ? 1 : 2,
          requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        );

        response = await sNetwork.getValidationModule().postPhoneVerificationRequest(model);
      }

      if (response.hasError) {
        _logger.log(stateFlow, 'sendCode', response.error);
        resendTapped = false;

        sNotification.showError(
          response.error!.cause,
          id: 1,
        );
      }
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);
      resendTapped = false;

      sNotification.showError(
        intl.something_went_wrong,
        id: 2,
      );
    }
  }

  @action
  Future<void> verifyCode() async {
    try {
      loader.startLoadingImmediately();

      late DC<ServerRejectException, void> response;

      if (args.isDeviceBinding) {
        final model = PostDeviceBindingVerifyModel(
          code: controller.text,
        );

        response = await sNetwork.getValidationModule().postDeviceBindingVerify(model);
      } else if (args.isUnlimitTransferConfirm) {
        final model = TransferVerifyCodeRequestModel(
          code: controller.text,
          transactionId: args.transactionId ?? '',
        );

        response = await sNetwork.getValidationModule().postTransferVerifyCode(model);
      } else {
        final number = await decomposePhoneNumber(
          phoneNumber,
          isoCodeNumber: dialCode?.isoCode ?? '',
        );

        final model = PhoneVerificationVerifyRequestModel(
          code: controller.text,
          phoneBody: number.body.replaceAll(
            dialCode?.countryCode ?? '',
            '',
          ),
          phoneCode: dialCode?.countryCode ?? '',
          phoneIso: number.isoCode,
        );

        response = await sNetwork.getValidationModule().postPhoneVerificationVerify(model);
      }

      if (response.hasError) {
        _logger.log(stateFlow, 'verifyCode', response.error);
        pinFieldError.enableError();

        loader.finishLoading();

        sNotification.showError(
          response.error!.cause,
          id: 1,
        );
      } else {
        sUserInfo.updatePhone(phoneNumber);
        args.onVerified();
      }
    } catch (e) {
      _logger.log(stateFlow, 'verifyCode', e);
      pinFieldError.enableError();

      loader.finishLoading();

      sNotification.showError(
        intl.something_went_wrong,
        id: 2,
      );
    }
  }

  @action
  Future<void> sendFullCode(bool isStart) async {
    try {
      if (args.isUnlimitTransferConfirm && isStart) return;

      if (!isStart) {
        resendTapped = true;
      }

      late DC<ServerRejectException, void> response;
      if (args.isDeviceBinding) {
        final model = PostDeviceBindingRequestModel(
          locale: intl.localeName,
          verificationType: isStart ? 1 : 2,
          requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        );

        response = await sNetwork.getValidationModule().postDeviceBindingRequest(model);
      } else if (args.isUnlimitTransferConfirm) {
        final model = TransferResendCodeRequestModel(
          transactionId: args.transactionId ?? '',
        );

        response = await sNetwork.getValidationModule().postTransferResendCode(model);
      } else {
        final model = PhoneVerificationFullRequestModel(
          locale: intl.localeName,
          verificationType: isStart ? 1 : 2,
          requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        );

        response = await sNetwork.getValidationModule().postPhoneVerificationFullRequest(model);
      }

      if (response.hasError) {
        _logger.log(stateFlow, 'sendCode', response.error);
        resendTapped = false;

        sNotification.showError(
          response.error!.cause,
          id: 1,
        );
      }
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);
      resendTapped = false;

      sNotification.showError(
        intl.something_went_wrong,
        id: 2,
      );
    }
  }

  @action
  Future<void> verifyFullCode(void Function() onLoaderStart) async {
    try {
      loader.startLoadingImmediately();
      onLoaderStart.call();

      late DC<ServerRejectException, void> response;

      if (args.isDeviceBinding) {
        final model = PostDeviceBindingVerifyModel(
          code: controller.text,
        );

        response = await sNetwork.getValidationModule().postDeviceBindingVerify(model);
      } else if (args.isUnlimitTransferConfirm) {
        final model = TransferVerifyCodeRequestModel(
          code: controller.text,
          transactionId: args.transactionId ?? '',
        );

        response = await sNetwork.getValidationModule().postTransferVerifyCode(model);
      } else {
        final model = PhoneVerificationFullVerifyRequestModel(
          code: controller.text,
        );

        response = await sNetwork.getValidationModule().postPhoneVerificationFullVerify(model);
      }

      if (response.hasError) {
        _logger.log(stateFlow, 'verifyCode', response.error);
        pinFieldError.enableError();

        sNotification.showError(
          response.error!.cause,
          id: 1,
        );
      } else {
        sUserInfo.updatePhone(phoneNumber);
        args.onVerified();
      }
    } catch (e) {
      _logger.log(stateFlow, 'verifyCode', e);
      pinFieldError.enableError();

      sNotification.showError(
        intl.something_went_wrong,
        id: 2,
      );
    }

    loader.finishLoading();
  }

  @action
  Future<void> pasteCode() async {
    _logger.log(notifier, 'pasteCode');

    final data = await Clipboard.getData('text/plain');
    final code = data?.text?.trim() ?? '';

    if (code.length == codeLength) {
      try {
        int.tryParse(code);

        controller.text = code;
      } catch (e) {
        return;
      }
    }
  }

  @action
  Future<void> _requestTemplate({
    required String requestName,
    required Future<void> Function() body,
  }) async {
    _logger.log(notifier, requestName);

    try {
      await body();
    } on ServerRejectException catch (e) {
      _logger.log(stateFlow, requestName, e);

      sNotification.showError(
        e.cause,
        id: 1,
      );
    } catch (e) {
      _logger.log(stateFlow, requestName, e);

      sNotification.showError(
        intl.something_went_wrong,
        id: 2,
      );
    }
  }

  @action
  void _updatePhoneNumber(String? number) {
    phoneNumber = number ?? '';
  }

  @action
  void _updateDialCode(SPhoneNumber? number) {
    dialCode = number;
  }

  @action
  void dispose() {
    focusNode.dispose();
    controller.dispose();
    pinFieldError.dispose();
    loader.dispose();
  }
}
