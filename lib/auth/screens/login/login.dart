import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/launch_url.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notifier.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notipod.dart';
import '../../shared/notifiers/authentication_notifier/authentication_union.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import '../forgot_password/view/forgot_password.dart';

class Login extends HookWidget {
  const Login({Key? key}) : super(key: key);

  static const routeName = '/login';

  static Future push(BuildContext context) {
    return Navigator.pushNamed(context, routeName);
  }

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
    final loader = useValueNotifier(StackLoaderNotifier());
    final disableContinue = useState(false);
    final _controller = useTextEditingController();

    return ProviderListener<AuthenticationUnion>(
      provider: authenticationNotipod,
      onChange: (context, union) {
        union.when(
          input: (error, st) {
            if (error != null) {
              disableContinue.value = false;
              loader.value.finishLoading();
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
        loading: loader.value,
        color: colors.grey5,
        header: SPaddingH24(
          child: SBigHeader(
            title: intl.login_signIn,
            showLink: true,
            linkText: intl.login_forgotPassword,
            onLinkTap: () => ForgotPassword.push(
              context: context,
              args: ForgotPasswordArgs(
                email: credentials.email,
              ),
            ),
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
                      color: colors.white,
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
                          controller: _controller,
                          onChanged: (String password) {
                            credentialsN.checkOnUpdateOrRemovePassword(
                              passwordError,
                              emailError,
                              password,
                              _controller,
                            );
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
                        padding: const EdgeInsets.only(
                          top: 34.0,
                          bottom: 17.0,
                        ),
                        child: SPolicyText(
                          firstText: '${intl.login_policyText1} ',
                          userAgreementText: intl.login_policyText2,
                          betweenText: ' ${intl.login_policyText3} ',
                          privacyPolicyText: intl.login_policyText4,
                          onUserAgreementTap: () {
                            launchURL(context, userAgreementLink);
                          },
                          onPrivacyPolicyTap: () {
                            launchURL(context, privacyPolicyLink);
                          },
                        ),
                      ),
                    ),
                    SPaddingH24(
                      child: SPrimaryButton2(
                        active: credentials.readyToLogin &&
                            !disableContinue.value &&
                            !loader.value.value,
                        name: intl.login_continueButton,
                        onTap: () {
                          disableContinue.value = true;
                          loader.value.startLoading();
                          authenticationN.authenticate(
                            email: credentials.email,
                            password: credentials.password,
                            operation: AuthOperation.login,
                          );
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
