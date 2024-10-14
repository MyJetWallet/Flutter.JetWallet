import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';

part 'change_email_store.g.dart';

class ChangeEmailStore extends _ChangeEmailStoreBase with _$ChangeEmailStore {
  ChangeEmailStore();

  static _ChangeEmailStoreBase of(BuildContext context) => Provider.of<ChangeEmailStore>(context, listen: false);
}

abstract class _ChangeEmailStoreBase with Store {
  final loader = StackLoaderStore();

  @observable
  bool isEmailError = false;

  @action
  bool setIsEmailError(bool value) => isEmailError = value;

  @action
  Future<void> changeEmail(String newEmail, String pin) async {
    try {
      loader.startLoadingImmediately();

      final response = await sNetwork.getWalletModule().postEmailChangeRequest(
            newEmail,
            pin,
          );

      if (response.hasData) {
        final result = response.data;

        if (result != null) {
          if (result.isSuccess) {
            await sRouter.replace(
              ChangeEmailVerificationRouter(
                verificationToken: result.verificationToken,
                pinCode: pin,
                newEmail: newEmail,
              ),
            );
          }
        }
      } else {
        if (response.hasError) {
          if (response.error!.errorCode == 'EmailUnavailable') {
            sNotification.showError(intl.register_invalidEmail);
          } else {
            sNotification.showError(response.error!.cause);
          }
        }
      }
      loader.finishLoading();
    } catch (e, stackTrace) {
      sNotification.showError(intl.something_went_wrong_try_again2);
      loader.finishLoading();
      if (kDebugMode) {
        print('[ChangeEmailStore] change email error: $e, stackTrace: $stackTrace');
      }
    }
  }
}
