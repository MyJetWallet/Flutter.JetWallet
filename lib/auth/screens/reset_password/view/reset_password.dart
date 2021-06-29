import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/components/spacers.dart';
import '../../../../shared/components/loader.dart';
import '../../../shared/auth_button_grey.dart';
import '../../../shared/auth_header_text.dart';
import '../../sign_in_up/provider/credentials_notipod.dart';
import '../../sign_in_up/view/components/password_text_field.dart';
import '../notifier/reset_password_union.dart';
import '../provider/reset_password_notipod.dart';

class ResetPassword extends HookWidget {
  const ResetPassword({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String? token;

  @override
  Widget build(BuildContext context) {
    final credentials = useProvider(credentialsNotipod);
    final forgotPassword = useProvider(resetPasswordNotipod);
    final notifier = useProvider(resetPasswordNotipod.notifier);

    return Scaffold(
      body: ProviderListener<ResetPasswordUnion>(
        provider: resetPasswordNotipod,
        onChange: (context, union) {
          union.when(
            input: (e, st) {
              if (e != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
              }
            },
            loading: () {},
          );
        },
        child: forgotPassword.when(
          input: (_, __) {
            return SafeArea(
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const AuthHeaderText(
                        text: 'Reset Password',
                      ),
                      const SpaceH20(),
                      const Text(
                        'Enter new password',
                        textAlign: TextAlign.start,
                      ),
                      PasswordTextField(
                        controller: credentials.passwordController,
                      ),
                      const Spacer(),
                      AuthButtonGrey(
                        text: 'Confirm',
                        onTap: () => notifier.resetPassword(token ?? ''),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => Loader(),
        ),
      ),
    );
  }
}
