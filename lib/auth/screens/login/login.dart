import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/launch_url.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../shared/components/notifications/show_errror_notification.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notifier.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notipod.dart';
import '../../shared/notifiers/authentication_notifier/authentication_union.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import '../forgot_password/view/forgot_password.dart';

class Login extends HookWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
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
              showErrorNotification(
                notificationQueueN,
                'The email and password you entered did not '
                'match our records. Please double-check '
                'and try again.',
              );
            }
          },
          loading: () {},
        );
      },
      child: SPageFrame(
        header: SPaddingH24(
          child: SBigHeader(
            title: 'Sign in',
            onBackButtonTap: () => Navigator.pop(context),
            showLink: true,
            linkText: 'Forgot password?',
            onLinkTap: () => navigatorPush(context, const ForgotPassword()),
          ),
        ),
        child: AutofillGroup(
          child: Material(
            color: colors.grey5,
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        color: SColorsLight().white,
                        child: SPaddingH24(
                          child: SStandardField(
                            labelText: 'Email Address',
                            autofocus: true,
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              emailError.value.disableError();
                              passwordError.value.disableError();
                              credentialsN.updateAndValidateEmail(value);
                            },
                            onErrorIconTap: () {
                              showErrorNotification(
                                notificationQueueN,
                                'The email and password you entered did not '
                                'match our records. Please double-check '
                                'and try again.',
                              );
                            },
                            errorNotifier: emailError.value,
                          ),
                        ),
                      ),
                      const SDivider(),
                      Material(
                        color: colors.white,
                        child: SPaddingH24(
                          child: SStandardFieldObscure(
                            autofillHints: const [AutofillHints.password],
                            onChanged: (value) {
                              emailError.value.disableError();
                              passwordError.value.disableError();
                              credentialsN.updateAndValidatePassword(value);
                            },
                            labelText: 'Password',
                            onErrorIconTap: () {
                              showErrorNotification(
                                notificationQueueN,
                                'The email and password you entered did not '
                                'match our records. Please double-check '
                                'and try again.',
                              );
                            },
                            errorNotifier: passwordError.value,
                          ),
                        ),
                      ),
                      const Spacer(),
                      SPaddingH24(
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: 34.h,
                            bottom: 17.h,
                          ),
                          child: SPolicyText(
                            firstText: 'By logging in and Continue, '
                                'I hereby agree and consent to the ',
                            userAgreementText: 'User Agreement',
                            betweenText: ' and the ',
                            privacyPolicyText: 'Privacy Policy',
                            onUserAgreementTap: () =>
                                launchURL(context, userAgreementLink),
                            onPrivacyPolicyTap: () =>
                                launchURL(context, privacyPolicyLink),
                          ),
                        ),
                      ),
                      SPaddingH24(
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

                              credentialsN.unreadyToLogin();
                            }
                          },
                        ),
                      ),
                      const SpaceH24(),
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
}
