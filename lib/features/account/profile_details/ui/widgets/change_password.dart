import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/account/profile_details/store/change_password_store.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'ChangePasswordRouter')
class ChangePassword extends StatelessObserverWidget {
  const ChangePassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final changePassword = ChangePasswordStore();
    final colors = sKit.colors;

    changePassword.union.maybeWhen(
      error: (error) {
        changePassword.setOldPasswordError(true);
      },
      orElse: () {},
    );

    return SPageFrame(
      loaderText: intl.changePassword_pleaseWait,
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.changePassword_changePassword,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          ColoredBox(
            color: colors.white,
            child: SPaddingH24(
              child: SStandardFieldObscure(
                autofillHints: const [AutofillHints.password],
                onChanged: (String password) {
                  changePassword.setInput();
                  changePassword.setOldPassword(password);
                },
                autofocus: true,
                labelText: intl.changePassword_enterCurrentPassword,
                onErrorIconTap: () {
                  sNotification.showError(
                    '${intl.changePassword_showErrorText1}!',
                    id: 1,
                  );
                },
                isError: changePassword.oldPasswordError,
              ),
            ),
          ),
          const Spacer(),
          SPaddingH24(
            child: SPrimaryButton2(
              name: intl.changePassword_continue,
              onTap: () {
                sRouter.push(
                  const SetNewPasswordRouter(),
                );
              },
              active: isPasswordValid(changePassword.oldPassword),
            ),
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
