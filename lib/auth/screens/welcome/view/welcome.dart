import 'package:flutter/material.dart';

import '../../../../shared/components/buttons/app_button_outlined.dart';
import '../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../shared/components/page_frame/page_frame.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../login/login.dart';
import '../../register/register.dart';
import 'components/app_version_text.dart';
import 'components/welcome_screen_text.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          const WelcomeScreenText(
            text: 'Welcome',
          ),
          const WelcomeScreenText(
            text: 'to the Simple',
          ),
          const Spacer(),
          AppButtonSolid(
            name: 'Create account',
            onTap: () => navigatorPush(context, const Register()),
          ),
          const SpaceH10(),
          AppButtonOutlined(
            name: 'I have an account',
            onTap: () => navigatorPush(context, const Login()),
          ),
          const SpaceH10(),
          const AppVersionText(),
        ],
      ),
    );
  }
}
