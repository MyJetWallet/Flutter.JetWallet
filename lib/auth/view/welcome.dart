import 'package:flutter/material.dart';

import '../../app/shared/helpers/navigator_push.dart';
import '../../shared/components/spacers.dart';
import 'components/app_version_text.dart';
import 'components/filled_button.dart';
import 'components/spot_outlined_button.dart';
import 'sign_in_sign_up.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Container()),
          const Text(
            'Welcome',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 46,
            ),
          ),
          const Text(
            'to the app',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 46,
            ),
          ),
          Expanded(child: Container()),
          SpotFilledButton(
            text: 'Create account',
            onTap: () => navigatorPush(
                context,
                const SignInSignUp(
                  isSignIn: false,
                )),
          ),
          const SpaceH15(),
          SpotOutlinedButton(
            text: 'I have an account',
            onTap: () => navigatorPush(
                context,
                const SignInSignUp(
                  isSignIn: true,
                )),
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
