import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/components/grey_24h_padding.dart';
import '../../../shared/components/notifications/show_errror_notification.dart';
import '../../../shared/components/password_validation/password_validation.dart';
import '../../../shared/notifiers/authentication_notifier/authentication_notifier.dart';
import '../../../shared/notifiers/authentication_notifier/authentication_notipod.dart';
import '../../../shared/notifiers/authentication_notifier/authentication_union.dart';
import '../../../shared/notifiers/credentials_notifier/credentials_notipod.dart';

class RegisterPasswordScreen extends HookWidget {
  const RegisterPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final authenticationN = useProvider(authenticationNotipod.notifier);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final passwordError = useValueNotifier(StandardFieldErrorNotifier());

    return ProviderListener<AuthenticationUnion>(
      provider: authenticationNotipod,
      onChange: (context, union) {
        union.when(
          input: (error, st) {
            if (error != null) {
              showPlainSnackbar(context, '$error');
            }
          },
          loading: () {},
        );
      },
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context);
          credentialsN.updateAndValidatePassword('');
          return Future.value(true);
        },
        child: SPageFrame(
          header: SPaddingH24(
            child: SBigHeader(
              title: 'Create a password',
              onBackButtonTap: () => Navigator.of(context).pop(),
            ),
          ),
          child: AutofillGroup(
            child: Material(
              color: colors.grey5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: colors.white,
                    child: SPaddingH24(
                      child: SStandardFieldObscure(
                        autofillHints: const [AutofillHints.password],
                        onChanged: (value) {
                          credentialsN.updateAndValidatePassword(value);
                        },
                        labelText: 'Password',
                        onErrorIconTap: () {
                          showErrorNotification(notificationQueueN, 'Error');
                        },
                        errorNotifier: passwordError.value,
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
                      active: credentialsN.readyToRegister,
                      name: 'Continue',
                      onTap: () {
                        if (credentialsN.readyToRegister) {
                          authenticationN.authenticate(
                            email: credentials.email,
                            password: credentials.password,
                            operation: AuthOperation.register,
                          );
                        }
                      },
                    ),
                  ),
                  const Grey24HPadding(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
