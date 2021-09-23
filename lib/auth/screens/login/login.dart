import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/components/buttons/app_button_outlined.dart';
import '../../../shared/components/buttons/app_button_solid.dart';
import '../../../shared/components/loader.dart';
import '../../../shared/components/page_frame/page_frame.dart';
import '../../../shared/components/spacers.dart';
import '../../../shared/components/text_fields/app_text_field.dart';
import '../../../shared/components/text_fields/app_text_field_obscure.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/helpers/navigator_push_replacement.dart';
import '../../../shared/helpers/show_plain_snackbar.dart';
import '../../shared/components/policy_check/policy_check_box.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notifier.dart';
import '../../shared/notifiers/authentication_notifier/authentication_notipod.dart';
import '../../shared/notifiers/authentication_notifier/authentication_union.dart';
import '../../shared/notifiers/credentials_notifier/credentials_notipod.dart';
import '../forgot_password/view/forgot_password.dart';
import '../register/register.dart';
import 'components/forgot_password_button.dart';

class Login extends HookWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final authenitcation = useProvider(authenticationNotipod);
    final authenitcationN = useProvider(authenticationNotipod.notifier);

    return ProviderListener<AuthenticationUnion>(
      provider: authenticationNotipod,
      onChange: (context, union) {
        union.when(
          input: (error, st) {
            if (error != null) {
              showPlainSnackbar(context, '$error');
            }
          },
          loading: () {},
        );
      },
      child: PageFrame(
        header: 'Sign in to simple',
        onBackButton: () => Navigator.pop(context),
        resizeToAvoidBottomInset: false,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH40(),
              AppTextField(
                header: 'Enter your email',
                hintText: 'Email address',
                autofillHints: const [AutofillHints.email],
                onChanged: (value) {
                  credentialsN.updateAndValidateEmail(value);
                },
              ),
              const SpaceH40(),
              AppTextFieldObscure(
                header: 'Enter password',
                hintText: 'Enter password',
                autofillHints: const [AutofillHints.password],
                onChanged: (value) {
                  credentialsN.updateAndValidatePassword(value);
                },
              ),
              const SpaceH40(),
              ForgotPasswordButton(
                onTap: () => navigatorPush(context, const ForgotPassword()),
              ),
              const Spacer(),
              const PolicyCheckBox(),
              const SpaceH10(),
              if (authenitcation is Input) ...[
                AppButtonSolid(
                  name: 'Sign in',
                  onTap: () {
                    if (credentialsN.readyToLogin) {
                      authenitcationN.authenticate(
                        email: credentials.email,
                        password: credentials.password,
                        operation: AuthOperation.login,
                      );
                    }
                  },
                  active: credentialsN.readyToLogin,
                ),
                const SpaceH10(),
                AppButtonOutlined(
                  name: 'Create account',
                  onTap: () {
                    navigatorPushReplacement(context, const Register());
                    credentialsN.clear();
                  },
                ),
              ] else ...[
                const Loader(),
                const Spacer(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
