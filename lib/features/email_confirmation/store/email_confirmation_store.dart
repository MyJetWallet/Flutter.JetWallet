import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/email_confirmation/models/email_confirmation_union.dart';
import 'package:jetwallet/utils/helpers/device_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:logger/logger.dart' as logger;
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/models/send_email/send_email_confirmation_request.dart';
import 'package:simple_networking/modules/validation_api/models/send_email/send_email_confirmation_response.dart';
import 'package:simple_networking/modules/validation_api/models/verify_email/verify_email_confirmation_request.dart';

part 'email_confirmation_store.g.dart';

class EmailConfirmationStore extends _EmailConfirmationStoreBase with _$EmailConfirmationStore {
  EmailConfirmationStore() : super();

  static _EmailConfirmationStoreBase of(BuildContext context) =>
      Provider.of<EmailConfirmationStore>(context, listen: false);
}

abstract class _EmailConfirmationStoreBase with Store {
  _EmailConfirmationStoreBase();

  late TimerStore timer;

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @action
  void init(TimerStore t) {
    timer = t;

    _updateEmail(getIt.get<AppStore>().authState.email);

    resendCode(
      onSuccess: () {
        timer.refreshTimer();
        showResendButton = false;
      },
    );
  }

  TextEditingController controller = TextEditingController();

  static final _logger = Logger('EmailVerificationStore');

  @observable
  String email = '';

  @observable
  EmailConfirmationUnion union = const EmailConfirmationUnion.input();

  @observable
  bool isResending = true;

  @observable
  bool showResendButton = false;

  SendEmailConfirmationResponse? sendEmailResponse;

  @action
  void updateResendButton(bool value) {
    showResendButton = value;
  }

  @action
  void updateCode(String? code) {
    _logger.log(notifier, 'updateCode');

    controller.text = code ?? '';
  }

  @action
  Future<void> pasteCode() async {
    _logger.log(notifier, 'pasteCode');

    final data = await Clipboard.getData('text/plain');
    final code = data?.text?.trim() ?? '';

    if (code.length == 6) {
      try {
        int.parse(code);
        controller.text = code;
      } catch (e) {
        return;
      }
    }
  }

  @action
  Future<void> resendCode({required Function() onSuccess}) async {
    _logger.log(notifier, 'resendCode');

    updateIsResending(true);

    try {
      final model = SendEmailConfirmationRequest(
        language: intl.localeName,
        deviceType: deviceType,
        type: 1,
        reason: 9,
      );

      final response = await sNetwork.getValidationModule().postSendEmailConfirmation(model);

      if (response.hasError) {
        _logger.log(stateFlow, 'sendCode', response.error);

        updateIsResending(false);
        showResendButton = true;
        sNotification.showError(
          '${intl.emailVerification_failedToResend}!',
        );

        return;
      }

      response.pick(
        onData: (data) {
          sendEmailResponse = data;
        },
      );

      updateIsResending(false);

      onSuccess();
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      updateIsResending(false);
      showResendButton = true;
      sNotification.showError(
        '${intl.emailVerification_failedToResend}!',
      );
    }
  }

  @action
  Future<void> verifyCode() async {
    loader.startLoadingImmediately();

    _logger.log(notifier, 'verifyCode');

    try {
      final model = VerifyEmailConfirmationRequest(
        tokenId: sendEmailResponse?.tokenId ?? '',
        verificationId: sendEmailResponse?.verificationId ?? '',
        code: controller.text,
      );

      final responce = await sNetwork.getValidationModule().postVerifyEmailConfirmation(model);

      responce.pick(
        onData: (data) async {
          getIt.get<SimpleLoggerService>().log(
                level: logger.Level.info,
                place: 'Email Confirmation Store',
                message: 'DELETE TOKEN: ${sendEmailResponse?.tokenId ?? ''}',
              );

          getIt.get<AppStore>().updateAuthState(
                deleteToken: sendEmailResponse?.tokenId ?? '',
              );

          final isAllowNavigation = sRouter.stack.any((rout) => rout.name == EmailConfirmationRouter.name);
          if (isAllowNavigation) {
            await sRouter.push(
              const DeleteReasonsScreenRouter(),
            );
          }
        },
        onError: (error) {
          _logger.log(stateFlow, 'verifyCode', error.cause);
          sNotification.showError(
            error.cause,
          );
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);
      sNotification.showError(
        intl.something_went_wrong,
      );
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);
      sNotification.showError(
        intl.something_went_wrong,
      );
    }
    loader.finishLoadingImmediately();
  }

  @action
  void _updateEmail(String newEmail) {
    email = newEmail;
  }

  @action
  void updateIsResending(bool value) {
    isResending = value;
  }

  @action
  void dispose() {
    controller.dispose();
  }
}
