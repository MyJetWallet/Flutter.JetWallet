import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/email_confirmation/models/email_confirmation_union.dart';
import 'package:jetwallet/utils/helpers/device_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/models/send_email/send_email_confirmation_request.dart';
import 'package:simple_networking/modules/validation_api/models/send_email/send_email_confirmation_response.dart';
import 'package:simple_networking/modules/validation_api/models/verify_email/verify_email_confirmation_request.dart';

part 'email_confirmation_store.g.dart';

class EmailConfirmationStore extends _EmailConfirmationStoreBase
    with _$EmailConfirmationStore {
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

      final response =
          await sNetwork.getValidationModule().postSendEmailConfirmation(model);

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
    _logger.log(notifier, 'verifyCode');

    union = const EmailConfirmationUnion.loading();

    try {
      final model = VerifyEmailConfirmationRequest(
        tokenId: sendEmailResponse?.tokenId ?? '',
        verificationId: sendEmailResponse?.verificationId ?? '',
        code: controller.text,
      );

      final _ = await sNetwork
          .getValidationModule()
          .postVerifyEmailConfirmation(model);

      _.pick(
        onData: (data) async {
          union = const EmailConfirmationUnion.input();

          print('DELETE TOKEN: ${sendEmailResponse?.tokenId ?? ''}');

          getIt.get<AppStore>().updateAuthState(
                deleteToken: sendEmailResponse?.tokenId ?? '',
              );

          await sRouter.push(
            const DeleteReasonsScreenRouter(),
          );
        },
        onError: (error) {
          _logger.log(stateFlow, 'verifyCode', error.cause);

          union = error.cause.contains('50') || error.cause.contains('40')
              ? EmailConfirmationUnion.error(
                  intl.something_went_wrong_try_again,
                )
              : EmailConfirmationUnion.error(error.cause);
          sNotification.showError(
            error.cause,
          );
        },
      );

      loader.finishLoadingImmediately();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'verifyCode', error.cause);

      union = error.cause.contains('50') || error.cause.contains('40')
          ? EmailConfirmationUnion.error(intl.something_went_wrong_try_again)
          : EmailConfirmationUnion.error(error.cause);
    } catch (error) {
      _logger.log(stateFlow, 'verifyCode', error);

      union = error.toString().contains('50') || error.toString().contains('40')
          ? EmailConfirmationUnion.error(intl.something_went_wrong_try_again)
          : EmailConfirmationUnion.error(error);
    }
  }

  @action
  void _updateEmail(String _email) {
    email = _email;
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
