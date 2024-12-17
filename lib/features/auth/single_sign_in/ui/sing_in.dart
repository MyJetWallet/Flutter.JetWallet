import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/auth/single_sign_in/models/single_sing_in_union.dart';
import 'package:jetwallet/features/auth/single_sign_in/store/single_sing_in_store.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';

@RoutePage(name: 'SingInRouter')
class SingIn extends StatelessWidget {
  const SingIn({
    super.key,
    this.email,
  });

  final String? email;

  @override
  Widget build(BuildContext context) {
    return Provider<SingleSingInStore>(
      create: (context) => SingleSingInStore(email),
      dispose: (context, value) => value.dispose(),
      builder: (context, child) => _SingInBody(
        email: email,
      ),
    );
  }
}

class _SingInBody extends StatelessObserverWidget {
  const _SingInBody({
    this.email,
  });

  final String? email;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    final credentials = getIt.get<CredentialsService>();
    final signInStore = SingleSingInStore.of(context);

    final controller = ScrollController();

    return ReactionBuilder(
      builder: (context) {
        return reaction<SingleSingInStateUnion>(
          (_) => signInStore.union,
          (result) {
            if (result is Loading) {
              signInStore.loader.startLoadingImmediately();
            } else if (result is Error) {
              signInStore.loader.finishLoading();

              sNotification.showError(
                (signInStore.union as Error).error.toString(),
              );
            } else if (result is ErrorSrting) {
              signInStore.loader.finishLoading();

              sNotification.showError(
                (signInStore.union as ErrorSrting).error!,
              );
            } else if (result is Success) {
              signInStore.loader.finishLoading();
              sAnalytics.signInFlowEmailVerificationView();
              sRouter.push(
                const EmailVerificationRoute(),
              );
            }
          },
          fireImmediately: true,
        );
      },
      child: SPageFrame(
        loaderText: intl.register_pleaseWait,
        color: colors.gray2,
        loading: signInStore.loader,
        header: SimpleLargeAppbar(
          title: intl.register_enterYourEmail,
          hasRightIcon: true,
          titleMaxLines: 2,
          rightIcon: SafeGesture(
            onTap: () async {
              if (showZendesk) {
                await getIt.get<IntercomService>().login();
                await getIt.get<IntercomService>().showMessenger();
              } else {
                await sRouter.push(
                  CrispRouter(
                    welcomeText: intl.crispSendMessage_hi,
                  ),
                );
              }
            },
            child: Assets.svg.medium.chat.simpleSvg(),
          ),
        ),
        child: CustomScrollView(
          physics: const ClampingScrollPhysics(),
          controller: controller,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ColoredBox(
                      color: colors.white,
                      child: AutofillGroup(
                        child: Observer(
                          builder: (context) {
                            return SInput(
                              controller: signInStore.emailController,
                              label: intl.login_emailTextFieldLabel,
                              autofocus: true,
                              initialValue: email,
                              autofillHints: const [AutofillHints.email],
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(
                                  RegExp('[ ]'),
                                ),
                              ],
                              onChanged: (value) {
                                credentials.updateAndValidateEmail(value);

                                if (value.isEmpty) {
                                  SingleSingInStore.of(context).setIsEmailError(false);
                                }
                                if (credentials.emailValid && SingleSingInStore.of(context).isEmailError) {
                                  SingleSingInStore.of(context).setIsEmailError(false);
                                }
                              },
                              onCloseIconTap: () {
                                SingleSingInStore.of(context).setIsEmailError(false);
                              },
                              hasCloseIcon: credentials.email.isNotEmpty,
                              onErrorIconTap: () {
                                sNotification.showError(
                                  intl.register_invalidEmail,
                                );
                              },
                              hasErrorIcon: SingleSingInStore.of(context).isEmailError,
                            );
                          },
                        ),
                      ),
                    ),
                    const Spacer(),
                    ColoredBox(
                      color: colors.gray2,
                      child: SPaddingH24(
                        child: SPolicyCheckbox(
                          firstText: '${intl.register_herebyConfirm} ',
                          userAgreementText: intl.register_TAndC,
                          betweenText: ' ${intl.register_andThe} ',
                          privacyPolicyText: intl.register_privacyPolicy,
                          isChecked: credentials.policyChecked,
                          onCheckboxTap: () {
                            controller.animateTo(
                              controller.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );

                            credentials.setPolicyChecked();
                          },
                          onUserAgreementTap: () {
                            launchURL(context, userAgreementLink);
                          },
                          onPrivacyPolicyTap: () {
                            launchURL(context, privacyPolicyLink);
                          },
                        ),
                      ),
                    ),
                    const SpaceH20(),
                    SPaddingH24(
                      child: SButton.blue(
                        text: intl.register_continue,
                        callback: credentials.emailIsNotEmptyAndPolicyChecked
                            ? () {
                                final logger = getIt.get<SimpleLoggerService>();
                                logger.log(
                                  level: Level.info,
                                  place: 'Sign in',
                                  message: 'Press button',
                                );
                                logger.log(
                                  level: Level.info,
                                  place: 'Sign in',
                                  message: 'credentials.emailValid = ${credentials.emailValid}',
                                );
                                if (credentials.emailValid) {
                                  SingleSingInStore.of(context).setIsEmailError(false);

                                  sAnalytics.signInFlowEmailContinue();

                                  logger.log(
                                    level: Level.info,
                                    place: 'Sign in',
                                    message: 'befor signInStore.singleSingIn',
                                  );

                                  signInStore.singleSingIn();
                                } else {
                                  logger.log(
                                    level: Level.info,
                                    place: 'Sign in',
                                    message: 'befor setIsEmailError(true)',
                                  );
                                  SingleSingInStore.of(context).setIsEmailError(true);

                                  logger.log(
                                    level: Level.info,
                                    place: 'Sign in',
                                    message: 'befor showError',
                                  );

                                  sNotification.showError(intl.register_invalidEmail);
                                }
                              }
                            : null,
                      ),
                    ),
                    const SpaceH42(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
