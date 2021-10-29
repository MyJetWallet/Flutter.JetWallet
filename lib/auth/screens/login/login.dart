import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/navigator_push.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notifier.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notipod.dart';
import '../../shared/notifiers/authentication_notifier/authentication_union.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import '../forgot_password/view/forgot_password.dart';

class Login extends HookWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final authenticationN = useProvider(authenticationNotipod.notifier);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final emailError = useValueNotifier(StandardFieldErrorNotifier());
    final passwordError = useValueNotifier(StandardFieldErrorNotifier());

    return ProviderListener<AuthenticationUnion>(
      provider: authenticationNotipod,
      onChange: (context, union) {
        union.when(
          input: (error, st) {
            if (error != null) {
              emailError.value.enableError();
              passwordError.value.enableError();
              _showErrorNotification(notificationQueueN);
            }
          },
          loading: () {},
        );
      },
      child: SPageFrame(
        header: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SBigHeader(
            title: 'Sign in',
            onBackButtonTap: () => Navigator.of(context).pop(),
            showLink: true,
            linkText: 'Forgot password?',
            onLinkTap: () => navigatorPush(context, const ForgotPassword()),
          ),
        ),
        child: AutofillGroup(
          child: Expanded(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: SStandardField(
                          labelText: 'Email Address',
                          autofocus: true,
                          autofillHints: const [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            credentialsN.updateAndValidateEmail(value);
                          },
                          onErrorIconTap: () {
                            _showErrorNotification(notificationQueueN);
                          },
                          errorNotifier: emailError.value,
                        ),
                      ),
                      const SDivider(),
                      Padding(
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
                        ),
                      ),
                      const Spacer(),
                      Container(
                        color: Colors.grey[200],
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: SPolicyText(
                            firstText: 'By logging in and Continue, '
                                'I hereby agree and consent to the ',
                            userAgreementText: 'User Agreement',
                            betweenText: ' and the ',
                            privacyPolicyText: 'Privacy Policy',
                            onUserAgreementTap: () {},
                            onPrivacyPolicyTap: () {},
                          ),
                        ),
                      ),
                      Material(
                        color: Colors.grey[200],
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: SPrimaryButton2(
                            active: credentialsN.readyToLogin,
                            name: 'Continue',
                            onTap: () {
                              if (credentialsN.readyToLogin) {
                                authenticationN.authenticate(
                                  email: credentials.email,
                                  password: credentials.password,
                                  operation: AuthOperation.login,
                                );
                              }
                            },
                          ),
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
              ],
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
            text: 'The email and password you entered did not match '
                'our records. Please double-check and try again.',
          );
        },
      ),
    );
  }
}
