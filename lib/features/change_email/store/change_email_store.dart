import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'change_email_store.g.dart';

class ChangeEmailStore extends _ChangeEmailStoreBase with _$ChangeEmailStore {
  ChangeEmailStore();

  static _ChangeEmailStoreBase of(BuildContext context) => Provider.of<ChangeEmailStore>(context, listen: false);
}

abstract class _ChangeEmailStoreBase with Store {
  @observable
  bool isLoading = false;

  @action
  bool setIsLoading(bool value) => isLoading = value;

  @observable
  bool isEmailError = false;

  @action
  bool setIsEmailError(bool value) => isEmailError = value;

  @action
  Future<void> changeEmail(String newEmail, String pin) async {
    try {
      setIsLoading(true);

      final response = await sNetwork.getWalletModule().postEmailChangeRequest(
            newEmail,
            pin,
          );

      if (response.hasData) {
        final result = response.data;

        if (result != null) {
          if (result.isSuccess) {
            await sRouter.push(
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
          sNotification.showError(response.error!.cause);
        }
      }
      setIsLoading(false);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('[ChangeEmailStore] change email error: $e, stackTrace: $stackTrace');
      }
    }
  }
}
