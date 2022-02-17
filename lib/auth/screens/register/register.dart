import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/analytics.dart';
import '../../../shared/helpers/launch_url.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
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
    final colors = useProvider(sColorPod);
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final emailError = useValueNotifier(StandardFieldErrorNotifier());

    analytics(() => sAnalytics.signUpView());

    void _showError() {
      sShowErrorNotification(
        notificationQueueN,
        'Perhaps you missed "." or "@" somewhere?',
      );
    }

    return SPageFrame(
      color: colors.grey5,
      header: const SPaddingH24(
        child: SBigHeader(
          title: 'Enter your Email',
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: colors.white,
            child: SPaddingH24(
              child: SStandardField(
                labelText: 'Email Address',
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  credentialsN.updateAndValidateEmail(value);
                },
                onErrorIconTap: () => _showError(),
                errorNotifier: emailError.value,
              ),
            ),
          ),
          const Spacer(),
          Container(
            color: colors.grey5,
            child: SPaddingH24(
              child: SPolicyCheckbox(
                firstText: 'I hereby confirm that I’m over 18 years old, '
                    'agree and consent to the ',
                userAgreementText: 'Terms & conditions',
                betweenText: ' and the ',
                privacyPolicyText: 'Privacy Policy',
                isChecked: credentials.policyChecked,
                onCheckboxTap: () => credentialsN.checkPolicy(),
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
              active: credentials.emailIsNotEmptyAndPolicyChecked,
              name: 'Continue',
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
    );
  }
}
