import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/launch_url.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notifier.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notipod.dart';
import '../../shared/notifiers/authentication_notifier/authentication_union.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import '../forgot_password/view/forgot_password.dart';

class Login extends HookWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final authenticationN = useProvider(authenticationNotipod.notifier);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final emailError = useValueNotifier(StandardFieldErrorNotifier());
    final passwordError = useValueNotifier(StandardFieldErrorNotifier());
    final loading = useValueNotifier(StackLoaderNotifier());

    return ProviderListener<AuthenticationUnion>(
      provider: authenticationNotipod,
      onChange: (context, union) {
        union.when(
          input: (error, st) {
            if (error != null) {
              loading.value.finishLoading();
              emailError.value.enableError();
              passwordError.value.enableError();
              sShowErrorNotification(
                notificationQueueN,
                intl.login_credentialsError,
              );
            }
          },
          loading: () {},
        );
      },
      child: SPageFrame(
        loading: loading.value,
        color: colors.grey5,
        header: SPaddingH24(
          child: SBigHeader(
            title: intl.login_signIn,
            onBackButtonTap: () => Navigator.pop(context),
            showLink: true,
            linkText: intl.login_forgotPassword,
            onLinkTap: () => navigatorPush(context, const ForgotPassword()),
          ),
        ),
        child: AutofillGroup(
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
                          labelText: intl.login_emailTextFieldLabel,
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
                            sShowErrorNotification(
                              notificationQueueN,
                              intl.login_credentialsError,
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
                          labelText: intl.login_passwordTextFieldLabel,
                          onErrorIconTap: () {
                            sShowErrorNotification(
                              notificationQueueN,
                              intl.login_credentialsError,
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
                          firstText: '${intl.login_policyText1} ',
                          userAgreementText: intl.login_policyText2,
                          betweenText: ' ${intl.login_policyText3} ',
                          privacyPolicyText: intl.login_policyText4,
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
                        name: intl.login_continueButton,
                        onTap: () {
                          if (credentialsN.readyToLogin) {
                            loading.value.startLoading();

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
    );
  }
}
