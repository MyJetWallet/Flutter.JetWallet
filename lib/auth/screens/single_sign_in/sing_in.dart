import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../app/screens/account/components/crisp.dart';
import '../../../shared/helpers/launch_url.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import '../email_verification/view/email_verification.dart';
import 'notifier/single_sing_in_notipod.dart';
import 'notifier/single_sing_in_state.dart';
import 'notifier/single_sing_in_union.dart';

class SingIn extends HookWidget {
  const SingIn({Key? key, this.email}) : super(key: key);

  static const routeName = '/sing_in';
  final String? email ;

  static Future push({
    required BuildContext context,
  }) {
    return Navigator.pushNamed(
      context,
      routeName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final singleSingInN = useProvider(singleSingInNotipod.notifier);
    final emailError = useValueNotifier(StandardFieldErrorNotifier());

    final controller = useScrollController();
    final loader = useValueNotifier(StackLoaderNotifier());
    useListenable(loader.value);

    return ProviderListener<SingleSingInState>(
      provider: singleSingInNotipod,
      child: SPageFrame(
        color: colors.grey5,
        loading: loader.value,
        header: SAuthHeader(
          customIconButton: const SpaceH24(),
          title: intl.register_enterYourEmail,
          showSupportButton: true,
          onSupportButtonTap: () => Crisp.push(
            context,
            intl.crispSendMessage_hi,
          ),
          progressValue: 20,
        ),
        child: CustomScrollView(
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
                            labelText: intl.login_emailTextFieldLabel,
                            autofocus: true,
                            initialValue: email,
                            autofillHints: const [AutofillHints.email],
                            keyboardType: TextInputType.emailAddress,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp('[ ]'))
                            ],
                            onChanged: (value) {
                              credentialsN.updateAndValidateEmail(value);
                            },
                            onErrorIconTap: () => notificationN
                                .showError(intl.register_invalidEmail),
                            errorNotifier: emailError.value,
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
                            credentialsN.checkPolicy();
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
                            singleSingInN.singleSingIn();
                          } else {
                            emailError.value.enableError();
                            notificationN.showError(intl.register_invalidEmail);
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
      ),
      onChange: (_, value) {
        if (value.union is Loading) {
          loader.value.startLoadingImmediately();
        } else if (value.union is Error) {
          loader.value.finishLoading();
          notificationN.showError((value.union as Error).error.toString());
        } else if (value.union is ErrorSrting) {
          loader.value.finishLoading();
          notificationN.showError((value.union as ErrorSrting).error!);
        } else if (value.union is Success) {
          loader.value.finishLoading();
          EmailVerification.push(context: context);
        }
      },
    );
  }
}
