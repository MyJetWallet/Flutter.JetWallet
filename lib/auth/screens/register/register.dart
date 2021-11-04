import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/helpers/launch_url.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import 'components/register_password_screen.dart';

class Register extends HookWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final emailError = useValueNotifier(StandardFieldErrorNotifier());

    return SPageFrame(
      header: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SBigHeader(
          title: 'Enter your Email',
          onBackButtonTap: () => Navigator.of(context).pop(),
        ),
      ),
      child: AutofillGroup(
        child: Expanded(
          child: Material(
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: SStandardField(
                    labelText: 'Email Address',
                    autofocus: true,
                    autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      credentialsN.updateAndValidateEmail(value);
                    },
                    onErrorIconTap: () {
                      _showErrorNotification(notificationQueueN);
                    },
                    errorNotifier: emailError.value,
                  ),
                ),
                const Spacer(),
                Container(
                  color: Colors.grey[200],
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                          _showErrorNotification(notificationQueueN);
                        }
                      }
                    },
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 24.h,
                  color: Colors.grey[200],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorNotification(SNotificationQueueNotifier notifier) {
    notifier.addToQueue(
      SNotification(
        duration: 3,
        function: (context) {
          showSNotification(
            context: context,
            duration: 3,
            text: 'Perhaps you missed "." or "@" somewhere?',
          );
        },
      ),
    );
  }
}
