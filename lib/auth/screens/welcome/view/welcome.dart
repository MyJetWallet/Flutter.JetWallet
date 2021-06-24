import 'package:flutter/material.dart';

import '../../../../app/shared/helpers/navigator_push.dart';
import '../../../../shared/components/spacers.dart';
import '../../../shared/auth_button.dart';
import '../../../shared/auth_button_pink.dart';
import '../../sign_in_up/view/sign_in_up.dart';
import 'components/app_version_text.dart';
import 'components/welcome_screen_text.dart';

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
          AuthButtonPink(
            text: 'Create account',
            onTap: () {
              navigatorPush(
                context,
                const SignInUp(
                  isSignIn: false,
                ),
              );
            },
          ),
          const SpaceH15(),
          AuthButton(
            text: 'I have an account',
            onTap: () {
              navigatorPush(
                context,
                const SignInUp(
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
