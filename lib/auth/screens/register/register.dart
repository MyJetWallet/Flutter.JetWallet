import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/analytics.dart';
import '../../../shared/helpers/launch_url.dart';
import '../../../shared/providers/service_providers.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import 'components/referral_code/referral_code.dart';
import 'register_password_screen.dart';

/// FLOW: Register -> RegisterPasswordScreen
class Register extends HookWidget {
  const Register({Key? key}) : super(key: key);

  static const routeName = '/register';

  static Future push(BuildContext context) {
    return Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final emailError = useValueNotifier(StandardFieldErrorNotifier());
    final controller = useScrollController();

    analytics(() => sAnalytics.signUpView());

    void _showError() {
      if (credentials.email.contains(' ')) {
        notificationN.showError(
          intl.register_invalidEmail,
          id: 2,
        );
      } else {
        notificationN.showError(
          '${intl.forgotPassword_error}?',
          id: 1,
        );
      }
    }

    void _scrollToBottom() {
      controller.animateTo(
        controller.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }

    return SPageFrame(
      color: colors.grey5,
      header: SPaddingH24(
        child: SBigHeader(
          title: intl.register_enterYourEmail,
        ),
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
                  Container(
                    color: colors.white,
                    child: SPaddingH24(
                      child: SStandardField(
                        labelText: intl.login_emailTextFieldLabel,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp('[ ]'))
                        ],
                        onChanged: (value) {
                          credentialsN.updateAndValidateEmail(value);
                        },
                        onErrorIconTap: () => _showError(),
                        errorNotifier: emailError.value,
                      ),
                    ),
                  ),
                  const SpaceH19(),
                  const ReferralCode(),
                  const Spacer(),
                  Container(
                    color: colors.grey5,
                    child: SPaddingH24(
                      child: SPolicyCheckbox(
                        firstText: '${intl.register_herebyConfirm} ',
                        userAgreementText: intl.register_TAndC,
                        betweenText: ' ${intl.register_andThe} ',
                        privacyPolicyText: intl.register_privacyPolicy,
                        isChecked: credentials.policyChecked,
                        onCheckboxTap: () {
                          _scrollToBottom();
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
                    child: SPrimaryButton2(
                      active: credentials.emailIsNotEmptyAndPolicyChecked,
                      name: intl.register_continue,
                      onTap: () {
                        if (credentials.emailValid) {
                          RegisterPasswordScreen.push(context);
                        } else {
                          emailError.value.enableError();
                          _showError();
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
  }
}
