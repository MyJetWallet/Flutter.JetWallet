import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../shared/components/spacers.dart';
import '../../../../shared/components/auth_frame/auth_frame.dart';
import '../../../../shared/components/buttons/auth_button_solid.dart';
import '../../../../shared/helpers/open_email_app.dart';
import 'forgot_description_text.dart';

class CheckYourEmail extends HookWidget {
  const CheckYourEmail(this.email);

  final String email;

  @override
  Widget build(BuildContext context) {
    return AuthFrame(
      header: 'Check Your Email',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        children: [
          ForgotDescriptionText(
            text: 'Recovery email with reset password instruction has been '
                'sent to $email',
          ),
          const SpaceH20(),
          const ForgotDescriptionText(
            text: 'If you don’t see the password recovery email in your inbox, '
                'check your spam folder',
          ),
          const Spacer(),
          AuthButtonSolid(
            name: 'Open Email App',
            onTap: () => openEmailApp(context),
          ),
        ],
      ),
    );
  }
}
