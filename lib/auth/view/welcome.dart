import 'package:flutter/material.dart';
import 'package:jetwallet/auth/view/components/welcome_screen_text.dart';

import '../../app/shared/helpers/navigator_push.dart';
import '../../shared/components/spacers.dart';
import 'components/app_version_text.dart';
import 'components/spot_button.dart';
import 'sign_in_sign_up.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Spacer(),
          const WelcomeScreenText(
            text: 'Welcome',
          ),
          const WelcomeScreenText(
            text: 'to the app',
          ),
          const Spacer(),
          SpotButton(
            text: 'Create account',
            onTap: () {
              navigatorPush(
                context,
                const SignInSignUp(
                  isSignIn: false,
                ),
              );
            },
            decoration: BoxDecoration(
              color: Colors.pink[400],
              borderRadius: BorderRadius.circular(8),
            ),
            textColor: Colors.white,
          ),
          const SpaceH15(),
          SpotButton(
            text: 'I have an account',
            onTap: () {
              navigatorPush(
                context,
                const SignInSignUp(
                  isSignIn: true,
                ),
              );
            },
            decoration: BoxDecoration(
              border: Border.all(),
              borderRadius: BorderRadius.circular(8),
            ),
            textColor: Colors.black,
          ),
          const SpaceH15(),
          const Center(
            child: AppVersionText(),
          ),
        ],
      ),
    );
  }
}
