import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../app/screens/account/components/crisp.dart';
import '../../../shared/helpers/analytics.dart';
import '../../../shared/helpers/launch_url.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../shared/helpers/password_validators.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notifier.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notipod.dart';
import '../../shared/notifiers/authentication_notifier/authentication_union.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import '../forgot_password/view/forgot_password.dart';

class Login extends HookWidget {
  const Login({
    Key? key,
    this.email,
  }) : super(key: key);

  static const routeName = '/login';
  final String? email;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final authenticationN = useProvider(authenticationNotipod.notifier);
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final emailError = useValueNotifier(StandardFieldErrorNotifier());
    final passwordError = useValueNotifier(StandardFieldErrorNotifier());
    final loader = useValueNotifier(StackLoaderNotifier());
    final disableContinue = useState(false);
    final _controller = useTextEditingController();
    final _customScrollController = useScrollController();
    final _focus = useFocusNode();

    analytics(() => sAnalytics.loginView());

    bool isButtonActive() {
      late bool isInputValid;

      if (email != null) {
        isInputValid = isPasswordLengthValid(credentials.password);
      } else {
        isInputValid = credentials.readyToLogin;
      }

      return isInputValid && !disableContinue.value && !loader.value.value;
    }

    void _onFocusChange() {
      if (_focus.hasFocus) {
        _customScrollController.animateTo(
          _customScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      }
    }

    _focus.addListener(_onFocusChange);

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
              notificationN.showError(
                error.toString(),
                id: 1,
              );
            }
          },
          loading: () {},
        );
      },
      child: SPageFrame(
        loaderText: intl.pleaseWait,
        loading: loader.value,
        color: colors.grey5,
        header: SPaddingH24(
          child: SBigHeader(
            showSupportButton: true,
            onSupportButtonTap: () => Crisp.push(
              context,
              intl.crispSendMessage_hi,
            ),
            title: intl.login_signIn,
            showLink: true,
            linkText: '${intl.login_forgotPassword}?',
            onLinkTap: () => ForgotPassword.push(
              context: context,
              args: ForgotPasswordArgs(
                email: credentials.email,
              ),
            ),
          ),
        ),
        child: CustomScrollView(
          controller: _customScrollController,
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
                        initialValue: email ?? '',
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]'))
                        ],
                        onChanged: (value) {
                          emailError.value.disableError();
                          passwordError.value.disableError();
                          credentialsN.updateAndValidateEmail(value);
                        },
                        onErrorIconTap: () {
                          notificationN.showError(
                            intl.login_credentialsError,
                            id: 2,
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
                        focusNode: _focus,
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
                        labelText: intl.password,
                        onErrorIconTap: () {
                          notificationN.showError(
                            intl.login_credentialsError,
                            id: 2,
                          );
                        },
                        errorNotifier: passwordError.value,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SPaddingH24(
                    child: SPolicyText(
                      firstText: intl.login_policyText1,
                      userAgreementText: ' ${intl.login_userAgreementText} ',
                      betweenText: '${intl.and_the} ',
                      privacyPolicyText: intl.privacy_policy,
                      onUserAgreementTap: () =>
                          launchURL(context, userAgreementLink),
                      onPrivacyPolicyTap: () =>
                          launchURL(context, privacyPolicyLink),
                    ),
                  ),
                  const SpaceH10(),
                  SPaddingH24(
                    child: SPrimaryButton2(
                      active: isButtonActive(),
                      name: intl.continueText,
                      onTap: () {
                        disableContinue.value = true;
                        loader.value.startLoading();
                        authenticationN.authenticate(
                          email: email ?? credentials.email,
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
    );
  }
}
