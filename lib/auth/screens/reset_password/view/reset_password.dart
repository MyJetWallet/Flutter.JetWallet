import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../shared/components/auth_frame/auth_frame.dart';
import '../../../shared/components/auth_success/auth_success.dart';
import '../../../shared/components/auth_text_field.dart';
import '../../../shared/components/buttons/auth_button_solid.dart';
import '../../../shared/components/password_validation/password_validation.dart';
import '../notifier/reset_password_notipod.dart';
import '../notifier/reset_password_state.dart';
import '../notifier/reset_password_union.dart';

class ResetPassword extends HookWidget {
  const ResetPassword({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;

  @override
  Widget build(BuildContext context) {
    final reset = useProvider(resetPasswordNotipod);
    final resetN = useProvider(resetPasswordNotipod.notifier);

    return ProviderListener<ResetPasswordState>(
      provider: resetPasswordNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            showPlainSnackbar(context, '$error');
          },
          orElse: () {},
        );
      },
      child: AuthFrame(
        header: 'Password reset',
        onBackButton: () => Navigator.pop(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH40(),
            AuthTextField(
              header: 'Enter new password',
              hintText: 'Create a password',
              obscureText: true,
              onChanged: (value) {
                resetN.updateAndValidatePassword(value);
              },
            ),
            PasswordValidation(
              password: reset.password,
            ),
            const Spacer(),
            if (reset.union is Loading) ...[
              const Loader(),
              const Spacer(),
            ] else
              AuthButtonSolid(
                name: 'Set new password',
                onTap: () {
                  if (reset.passwordValid) {
                    resetN.resetPassword(token);

                    if (reset.union is Input) {
                      _pushToAuthSuccess(context);
                    }
                  }
                },
                active: reset.passwordValid,
              )
          ],
        ),
      ),
    );
  }
}

void _pushToAuthSuccess(BuildContext context) {
  navigatorPush(
    context,
    const AuthSuccess(
      header: 'Password reset',
      description: 'Your password has been reset',
    ),
  );
}
