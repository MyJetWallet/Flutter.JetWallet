import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../shared/auth_button_grey.dart';
import '../../email_verification/view/email_verification.dart';
import '../../forgot_password/view/forgot_password.dart';
import '../notifier/authentication_notifier/authentication_union.dart';
import '../provider/auth_screen_stpod.dart';
import '../provider/authentication_notipod.dart';
import '../provider/credentials_notipod.dart';
import 'components/email_text_field.dart';
import 'components/password_text_field.dart';

class SignInUp extends HookWidget {
  const SignInUp({
    Key? key,
    required this.isSignIn,
  }) : super(key: key);

  final bool isSignIn;

  @override
  Widget build(BuildContext context) {
    final credentials = useProvider(credentialsNotipod);
    final auth = useProvider(authenticationNotipod);
    final notifier = useProvider(authenticationNotipod.notifier);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ProviderListener<AuthenticationUnion>(
        provider: authenticationNotipod,
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
        child: auth.when(
          input: (_, __) {
            return SafeArea(
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        isSignIn ? 'Log In' : 'Create an account',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                      const SpaceH20(),
                      const Text(
                        'Enter your email',
                        textAlign: TextAlign.start,
                      ),
                      EmailTextField(
                        controller: credentials.emailController,
                      ),
                      const SpaceH30(),
                      const Text(
                        'Enter password',
                        textAlign: TextAlign.start,
                      ),
                      PasswordTextField(
                        controller: credentials.passwordController,
                      ),
                      const SpaceH20(),
                      if (isSignIn)
                        AuthButtonGrey(
                          text: 'Forgot Password',
                          onTap: () {
                            navigatorPush(context, const ForgotPassword());
                          },
                        )
                      else
                        Container(),
                      const Spacer(),
                      AuthButtonGrey(
                        text: 'Continue',
                        onTap: () {
                          notifier.authenticate(
                            isSignIn ? AuthScreen.signIn : AuthScreen.signUp,
                          );
                        },
                      ),
                      const SpaceH20(),
                      AuthButtonGrey(
                        text: 'Temp (Confirm)',
                        onTap: () {
                          navigatorPush(
                            context,
                            const EmailVerification(code: '3333'),
                          );
                        },
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
