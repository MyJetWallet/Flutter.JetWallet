import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../shared/components/loader.dart';
import '../../../../shared/components/page_frame/page_frame.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/components/text_fields/app_text_field.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/helpers/show_plain_snackbar.dart';
import '../notifier/forgot_password_notipod.dart';
import '../notifier/forgot_password_state.dart';
import '../notifier/forgot_password_union.dart';
import 'components/check_your_email.dart';
import 'components/forgot_description_text.dart';

class ForgotPassword extends StatefulHookWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final forgot = useProvider(forgotPasswordNotipod);
    final forgotN = useProvider(forgotPasswordNotipod.notifier);

    return ProviderListener<ForgotPasswordState>(
      provider: forgotPasswordNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            showPlainSnackbar(context, '$error');
          },
          orElse: () {},
        );
      },
      child: PageFrame(
        header: 'Forgot Password',
        onBackButton: () => Navigator.pop(context),
        child: Column(
          children: [
            const SpaceH10(),
            const ForgotDescriptionText(
              text: 'Resetting a forgotten password will logout other devices '
                  'and will result in a 24-hour hold on cryptocurrency '
                  'withdrawals.',
            ),
            const SpaceH80(),
            AppTextField(
              header: 'Enter your email',
              hintText: 'Email address',
              onChanged: (value) => forgotN.updateAndValidateEmail(value),
            ),
            const Spacer(),
            if (forgot.union is Loading)
              const Loader()
            else
              AppButtonSolid(
                name: 'Send reset email',
                onTap: () async {
                  if (forgot.emailValid) {
                    final email = forgot.email;

                    await forgotN.sendRecoveryLink();

                    if (forgot.union is Input) {
                      if (!mounted) return;
                      navigatorPush(context, CheckYourEmail(email));
                    }
                  }
                },
                active: forgot.emailValid,
              ),
          ],
        ),
      ),
    );
  }
}
