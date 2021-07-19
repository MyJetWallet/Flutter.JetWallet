import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/components/spacers.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../shared/components/auth_frame/auth_frame.dart';
import '../../shared/components/auth_text_field.dart';
import '../../shared/components/buttons/auth_button_solid.dart';
import '../../shared/components/policy_check/policy_check_box.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import 'components/register_password_screen.dart';

class Register extends HookWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);

    return AuthFrame(
      header: 'Create an account',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH40(),
          AuthTextField(
            header: 'Enter your email',
            hintText: 'Email address',
            onChanged: (value) => credentialsN.updateAndValidateEmail(value),
          ),
          const Spacer(),
          PolicyCheckBox(
            onTap: () => credentialsN.checkPolicy(),
            isChecked: credentials.policyChecked,
          ),
          const SpaceH15(),
          AuthButtonSolid(
            name: 'Continue',
            onTap: () {
              if (credentialsN.emailValidAndPolicyChecked) {
                navigatorPush(context, const RegisterPasswordScreen());
              }
            },
            active: credentialsN.emailValidAndPolicyChecked,
          )
        ],
      ),
    );
  }
}
