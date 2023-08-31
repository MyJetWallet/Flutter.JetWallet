import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/account/profile_details/store/change_password_store.dart';
import 'package:jetwallet/features/account/profile_details/ui/widgets/password_validation.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'SetNewPasswordRouter')
class SetNewPassword extends StatelessObserverWidget {
  const SetNewPassword({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final changePassword = ChangePasswordStore();
    final credentials = getIt.get<CredentialsService>();
    final colors = sKit.colors;
    final loading = StackLoaderStore();

    changePassword.union.when(
      error: (error) {
        loading.finishLoadingImmediately();
        sNotification.showError('$error', id: 1);
        Navigator.pop(context);
      },
      input: () {},
      done: () {
        sRouter.push(
          SuccessScreenRouter(
            secondaryText: intl.setNewPassword_newPasswordSet,
          ),
        );
      },
    );

    return SPageFrame(
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.setNewPassword_createPassword,
          onBackButtonTap: () => Navigator.of(context).pop(),
        ),
      ),
      loading: loading,
      loaderText: intl.setNewPassword_pleaseWait,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ColoredBox(
            color: colors.white,
            child: SPaddingH24(
              child: SStandardFieldObscure(
                onChanged: (String password) {
                  changePassword.setNewPassword(password);

                  credentials.updateAndValidatePassword(password);
                },
                labelText: intl.setNewPassword_createANewPassword,
                autofocus: true,
              ),
            ),
          ),
          SPaddingH24(
            child: PasswordValidation(
              password: credentials.password,
            ),
          ),
          const Spacer(),
          SPaddingH24(
            child: SPrimaryButton2(
              active: changePassword.isNewPasswordButtonActive,
              name: intl.setNewPassword_setNewPassword,
              onTap: () {
                loading.startLoading();
                changePassword.confirmNewPassword();
              },
            ),
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
