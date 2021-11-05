import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/launch_url.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../shared/components/grey_24h_padding.dart';
import '../../shared/components/notifications/show_errror_notification.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import 'components/register_password_screen.dart';

class Register extends HookWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final emailError = useValueNotifier(StandardFieldErrorNotifier());

    return SPageFrame(
      header: SPaddingH24(
        child: SBigHeader(
          title: 'Enter your Email',
          onBackButtonTap: () => Navigator.of(context).pop(),
        ),
      ),
      child: AutofillGroup(
        child: Expanded(
          child: Material(
            color: colors.grey5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: colors.white,
                  child: SPaddingH24(
                    child: SStandardField(
                      labelText: 'Email Address',
                      autofocus: true,
                      autofillHints: const [AutofillHints.email],
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        credentialsN.updateAndValidateEmail(value);
                      },
                      onErrorIconTap: () {
                        showErrorNotification(
                          notificationQueueN,
                          'Perhaps you missed "." or "@" somewhere?',
                        );
                      },
                      errorNotifier: emailError.value,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  color: colors.grey5,
                  child: SPaddingH24(
                    child: SPolicyCheckbox(
                      firstText: 'By clicking Agree and Continue, '
                          'I hereby agree and consent to the ',
                      userAgreementText: 'User Agreement',
                      betweenText: ' and the ',
                      privacyPolicyText: 'Privacy Policy',
                      isChecked: credentials.policyChecked,
                      onCheckboxTap: () => credentialsN.checkPolicy(),
                      onUserAgreementTap: () =>
                          launchURL(context, userAgreementLink),
                      onPrivacyPolicyTap: () =>
                          launchURL(context, privacyPolicyLink),
                    ),
                  ),
                ),
                SPaddingH24(
                  child: SPrimaryButton2(
                    active: credentialsN.emailIsNotEmptyAndPolicyChecked,
                    name: 'Continue',
                    onTap: () {
                      if (credentialsN.emailIsNotEmptyAndPolicyChecked) {
                        if (credentials.emailValid) {
                          navigatorPush(
                            context,
                            const RegisterPasswordScreen(),
                          );
                        } else {
                          emailError.value.enableError();
                          showErrorNotification(
                            notificationQueueN,
                            'Perhaps you missed "." or "@" somewhere?',
                          );
                        }
                      }
                    },
                  ),
                ),
                const Grey24HPadding(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
