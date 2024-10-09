import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/email_verification/model/email_verification_union.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';

part 'change_email_verification_store.g.dart';

class ChangeEmailVerificationStore extends _ChangeEmailVerificationStoreBase with _$ChangeEmailVerificationStore {
  ChangeEmailVerificationStore(
    super.verificationToken,
    super.pinCode,
    super.newEmail,
  );

  static _ChangeEmailVerificationStoreBase of(BuildContext context) =>
      Provider.of<ChangeEmailVerificationStore>(context, listen: false);
}

abstract class _ChangeEmailVerificationStoreBase with Store {
  _ChangeEmailVerificationStoreBase(
    this.verificationToken,
    this.pinCode,
    this.newEmail,
  ) {
    _updateEmail(newEmail);
  }

  String verificationToken;
  final String pinCode;
  final String newEmail;

  final loader = StackLoaderStore();
  final pinError = StandardFieldErrorNotifier();

  @observable
  String email = '';

  @observable
  EmailVerificationUnion union = const EmailVerificationUnion.input();

  @observable
  bool isResending = false;

  @observable
  TextEditingController controller = TextEditingController();

  @action
  void updateCode(String? code) {
    controller.text = code ?? '';
  }

  @action
  Future<void> pasteCode() async {
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
  Future<void> resendCode(TimerStore timer) async {
    _updateIsResending(true);
    try {
      final response = await sNetwork.getWalletModule().postEmailChangeRequest(
            newEmail,
            pinCode,
          );

      response.pick(
        onData: (data) {
          timer.refreshTimer();

          _updateIsResending(false);

          verificationToken = data.verificationToken;
        },
        onError: (error) {
          _updateIsResending(false);
          sNotification.showError(
            '${intl.emailVerification_failedToResend}!',
          );
        },
      );
    } catch (e) {
      _updateIsResending(false);
      sNotification.showError(
        '${intl.emailVerification_failedToResend}!',
      );
    }
  }

  @action
  Future<void> verifyCode() async {
    union = const EmailVerificationUnion.loading();

    final storageService = sLocalStorageService;
    final authInfo = getIt.get<AppStore>();

    try {
      final response = await sNetwork.getWalletModule().postEmailVerifyRequest(
            verificationToken,
            controller.text,
          );

      if (response.hasError) {
        pinError.enableError();

        loader.finishLoading();

        sNotification.showError(
          response.error!.cause.contains('50') || response.error!.cause.contains('40')
              ? intl.something_went_wrong_try_again
              : response.error!.cause,
          id: 1,
        );
      } else {
        authInfo.updateAuthState(email: newEmail);

        await storageService.setString(
          userEmailKey,
          newEmail,
        );

        union = const EmailVerificationUnion.input();
        loader.finishLoading();

        await sRouter.push(
          SuccessScreenRouter(
            secondaryText: intl.change_email_success_hint(newEmail),
            onSuccess: (context) {
              sRouter.popUntil(
                (route) => route.settings.name == ProfileDetailsRouter.name,
              );
            },
          ),
        );
      }
    } on ServerRejectException catch (error) {
      pinError.enableError();

      union = error.cause.contains('50') || error.cause.contains('40')
          ? EmailVerificationUnion.error(intl.something_went_wrong_try_again)
          : EmailVerificationUnion.error(error.cause);
    } catch (error) {
      pinError.enableError();

      union = error.toString().contains('50') || error.toString().contains('40')
          ? EmailVerificationUnion.error(intl.something_went_wrong_try_again)
          : EmailVerificationUnion.error(error);
    }
  }

  @action
  void _updateEmail(String newEmail) {
    email = newEmail;
  }

  @action
  void _updateIsResending(bool value) {
    isResending = value;
  }

  @action
  void clearStore() {
    loader.finishLoadingImmediately();
    email = '';
    union = const EmailVerificationUnion.input();
    isResending = false;
    controller = TextEditingController(text: '');
  }
}
