import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/components/spacers.dart';
import '../../../shared/helpers/navigate_to_router.dart';
import '../../../shared/providers/other/navigator_key_pod.dart';
import '../../../shared/providers/other/timer_notipod.dart';
import '../../shared/auth_frame.dart';
import '../../shared/auth_header_text.dart';
import 'components/email_is_confirmed_text.dart';
import 'components/success_text.dart';

class EmailVerificationSuccess extends HookWidget {
  const EmailVerificationSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigatorKey = useProvider(navigatorKeyPod);

    return ProviderListener<int>(
      provider: timerNotipod(3),
      onChange: (context, value) {
        if (value == 0) navigateToRouter(navigatorKey);
      },
      child: Scaffold(
        body: AuthScreenFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeaderText(
                text: 'Email Verification',
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                    ),
                    Icon(
                      FontAwesomeIcons.checkCircle,
                      size: 150.0,
                    ),
                    SpaceH40(),
                    SuccessText(),
                    SpaceH20(),
                    EmailIsConfirmedText(),
                    Spacer(),
                    LinearProgressIndicator(
                      minHeight: 10.0,
                      color: Colors.grey,
                      backgroundColor: Color(0xffeeeeee),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
