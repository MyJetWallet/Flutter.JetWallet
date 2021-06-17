import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/components/spacers.dart';
import '../../shared/components/loader.dart';
import '../notifier/authentication_notifier/authentication_union.dart';
import '../provider/auth_screen_stpod.dart';
import '../provider/authentication_notipod.dart';
import '../provider/credentials_notipod.dart';
import 'components/filled_button.dart';
import 'components/text_fields/email_text_field.dart';
import 'components/text_fields/password_text_field.dart';

class SignInSignUp extends HookWidget {
  const SignInSignUp({
    Key? key,
    required this.isSignIn,
  }) : super(key: key);

  final bool isSignIn;

  @override
  Widget build(BuildContext context) {
    final credentials = useProvider(credentialsNotipod);
    final auth = useProvider(authenticationNotipod);
    final notifier = useProvider(authenticationNotipod.notifier);

    return ProviderListener<AuthenticationUnion>(
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
            child: Scaffold(
              body: Form(
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
                        style: TextStyle(),
                      ),
                      EmailTextField(
                        controller: credentials.emailController,
                      ),
                      const SpaceH30(),
                      const Text(
                        'Enter password',
                        textAlign: TextAlign.start,
                        style: TextStyle(),
                      ),
                      PasswordTextField(
                        controller: credentials.passwordController,
                      ),
                      Expanded(child: Container()),
                      SpotFilledButton(
                        text: 'Continue',
                        onTap: () {
                          notifier.authenticate(
                              isSignIn ? AuthScreen.signIn : AuthScreen.signUp);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => Loader(),
      ),
    );
  }
}
