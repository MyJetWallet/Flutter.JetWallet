import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/credentials_service/credentials_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/auth/single_sign_in/models/single_sing_in_union.dart';
import 'package:jetwallet/features/auth/single_sign_in/store/single_sing_in_store.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/primary_button/public/simple_primary_button_4.dart';
import 'package:simple_kit/modules/headers/simple_auth_header.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

class SingIn extends StatelessWidget {
  const SingIn({
    Key? key,
    this.email,
  }) : super(key: key);

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
    Key? key,
    this.email,
  }) : super(key: key);

  final String? email;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

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

              sRouter.push(
                const EmailVerificationRoute(),
              );
            }
          },
          fireImmediately: true,
        );
      },
      child: Observer(
        builder: (context) {
          return SPageFrame(
            loaderText: intl.register_pleaseWait,
            color: colors.grey5,
            loading: signInStore.loader,
            header: SAuthHeader(
              customIconButton: const SpaceH24(),
              title: intl.register_enterYourEmail,
              showSupportButton: false,
              /*onSupportButtonTap: () => sRouter.push(
                CrispRouter(
                  welcomeText: intl.crispSendMessage_hi,
                ),
              ),
              */
              progressValue: 20,
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
                          child: SPaddingH24(
                            child: AutofillGroup(
                              child: SStandardField(
                                controller: signInStore.emailController,
                                labelText: intl.login_emailTextFieldLabel,
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
                                },
                                onErrorIconTap: () => sNotification.showError(
                                  intl.register_invalidEmail,
                                ),
                                isError:
                                    SingleSingInStore.of(context).isEmailError,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        ColoredBox(
                          color: colors.grey5,
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
                        const SpaceH16(),
                        SPaddingH24(
                          child: SPrimaryButton4(
                            active: credentials.emailIsNotEmptyAndPolicyChecked,
                            name: intl.register_continue,
                            onTap: () {
                              if (credentials.emailValid) {
                                signInStore.singleSingIn();
                              } else {
                                SingleSingInStore.of(context)
                                    .setIsEmailError(true);

                                sNotification
                                    .showError(intl.register_invalidEmail);
                              }
                            },
                          ),
                        ),
                        const SpaceH24(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
