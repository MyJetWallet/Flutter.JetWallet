import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_notifications/simple_notifications.dart';
import 'package:jetwallet/features/auth/login/store/login_store.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key? key,
    this.email,
  }) : super(key: key);

  final String? email;

  @override
  Widget build(BuildContext context) {
    return Provider<LoginStore>(
      create: (context) => LoginStore(email: email),
      builder: (context, child) => _LoginBody(
        email: email,
      ),
      dispose: (context, state) => state.dispose(),
    );
  }
}

class _LoginBody extends StatelessObserverWidget {
  const _LoginBody({
    Key? key,
    this.email,
  }) : super(key: key);

  final String? email;

  @override
  Widget build(BuildContext context) {
    final sKit = getIt.get<SimpleKit>();
    final sNoty = getIt.get<SNotificationNotifier>();

    return SPageFrame(
      loaderText: intl.login_pleaseWait,
      loading: LoginStore.of(context).loader,
      color: sKit.colors.grey5,
      header: SPaddingH24(
        child: SBigHeader(
          showSupportButton: true,
          onSupportButtonTap: () => {
            /*Crisp.push(
            context,
            intl.crispSendMessage_hi,
            )*/
          },
          title: intl.login_signIn,
          showLink: true,
          linkText: '${intl.login_forgotPassword}?',
          onLinkTap: () => {
            /*
            ForgotPassword.push(
              context: context,
              args: ForgotPasswordArgs(
                email: credentials.email,
              ),
            )
            */
          },
        ),
      ),
      child: CustomScrollView(
        controller: LoginStore.of(context).customScrollController,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: AutofillGroup(
              child: Form(
                key: LoginStore.of(context).formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Material(
                      color: sKit.colors.white,
                      child: SPaddingH24(
                        child: SStandardField(
                          controller: LoginStore.of(context).emailController,
                          focusNode: LoginStore.of(context).emailFocusNode,
                          labelText: intl.login_emailTextFieldLabel,
                          autofocus: true,
                          autofillHints: const [AutofillHints.email],
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp('[ ]')),
                          ],
                          onChanged: (value) {
                            getIt
                                .get<CredentialsService>()
                                .updateAndValidateEmail(value);
                            LoginStore.of(context).disableError();
                          },
                          onErrorIconTap: () {
                            sNoty.showError(
                              intl.login_credentialsError,
                              id: 2,
                              needFeedback: true,
                            );
                          },
                          isError: LoginStore.of(context).emailError,
                        ),
                      ),
                    ),
                    const SDivider(),
                    Material(
                      color: sKit.colors.white,
                      child: SPaddingH24(
                        child: SStandardFieldObscure(
                          controller: LoginStore.of(context).passwordController,
                          focusNode: LoginStore.of(context).passwordFocusNode,
                          autofillHints: const [AutofillHints.password],
                          onChanged: (String password) {
                            getIt
                                .get<CredentialsService>()
                                .updateAndValidatePassword(password);
                            LoginStore.of(context).disableError();
                          },
                          labelText: intl.login_password,
                          onErrorIconTap: () {
                            sNoty.showError(
                              intl.login_credentialsError,
                              id: 2,
                              needFeedback: true,
                            );
                          },
                          isError: LoginStore.of(context).passwordError,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SPaddingH24(
                      child: SPolicyText(
                        firstText: intl.login_policyText1,
                        userAgreementText: ' ${intl.login_userAgreementText} ',
                        betweenText: '${intl.login_andThe} ',
                        privacyPolicyText: intl.login_privacyPolicy,
                        onUserAgreementTap: () => launchURL(
                          context,
                          userAgreementLink,
                        ),
                        onPrivacyPolicyTap: () => launchURL(
                          context,
                          privacyPolicyLink,
                        ),
                      ),
                    ),
                    const SpaceH10(),
                    SPaddingH24(
                      child: SPrimaryButton2(
                        active: LoginStore.of(context).isButtonActive,
                        name: intl.login_continue,
                        onTap: () {
                          LoginStore.of(context)
                              .loader
                              .startLoadingImmediately();

                          LoginStore.of(context).setDisableContinue(true);

                          getIt
                              .get<CredentialsService>()
                              .authenticate(
                                operation: AuthOperation.login,
                                showError: (error) {
                                  LoginStore.of(context).showError(error);
                                },
                              )
                              .then(
                            (value) {
                              LoginStore.of(context).loader.finishLoading();
                              LoginStore.of(context).setDisableContinue(false);
                            },
                          );
                        },
                      ),
                    ),
                    const SpaceH24(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
