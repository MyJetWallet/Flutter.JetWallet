import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/components/password_validation/password_validation.dart';
import '../../../shared/notifiers/authentication_notifier/authentication_notifier.dart';
import '../../../shared/notifiers/authentication_notifier/authentication_notipod.dart';
import '../../../shared/notifiers/authentication_notifier/authentication_union.dart';
import '../../../shared/notifiers/credentials_notifier/credentials_notipod.dart';

class RegisterPasswordScreen extends HookWidget {
  const RegisterPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          header: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: SBigHeader(
              title: 'Create a password',
              onBackButtonTap: () => Navigator.of(context).pop(),
            ),
          ),
          child: AutofillGroup(
            child: Expanded(
              child: Material(
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: SStandardFieldObscure(
                        autofillHints: const [AutofillHints.password],
                        onChanged: (value) {
                          credentialsN.updateAndValidatePassword(value);
                        },
                        labelText: 'Password',
                        onErrorIconTap: () {
                          _showErrorNotification(notificationQueueN);
                        },
                        errorNotifier: passwordError.value,
                        autofocus: true,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: PasswordValidation(
                        password: credentials.password,
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                    Container(
                      width: double.infinity,
                      height: 24.h,
                      color: Colors.grey[200],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorNotification(SNotificationQueueNotifier notifier) {
    notifier.addToQueue(
      SNotification(
        duration: 3,
        function: (context) {
          showSNotification(
            context: context,
            duration: 3,
            text: 'Error',
          );
        },
      ),
    );
  }
}
