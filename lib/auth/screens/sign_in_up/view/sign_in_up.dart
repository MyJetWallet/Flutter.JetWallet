import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../shared/components/auth_button_grey.dart';
import '../../forgot_password/view/forgot_password.dart';
import '../notifier/authentication_notifier/authentication_notipod.dart';
import '../notifier/authentication_notifier/authentication_union.dart';
import '../notifier/credentials_notifier/credentials_notipod.dart';
import '../provider/auth_screen_stpod.dart';
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
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        isSignIn ? 'Log In' : 'Create an account',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 28.sp,
                        ),
                      ),
                      const SpaceH15(),
                      const Text(
                        'Enter your email',
                        textAlign: TextAlign.start,
                      ),
                      EmailTextField(
                        controller: credentials.emailController,
                      ),
                      const SpaceH25(),
                      const Text(
                        'Enter password',
                        textAlign: TextAlign.start,
                      ),
                      PasswordTextField(
                        controller: credentials.passwordController,
                      ),
                      const SpaceH15(),
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
                    ],
                  ),
                ),
              ),
            );
          },
          loading: () => const Loader(),
        ),
      ),
    );
  }
}
