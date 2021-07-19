import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../router/provider/authorized_stpod/authorized_stpod.dart';
import '../../../router/provider/authorized_stpod/authorized_union.dart';
import '../../../shared/components/spacers.dart';
import '../../../shared/helpers/navigate_to_router.dart';
import '../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../shared/providers/other/navigator_key_pod.dart';
import '../../shared/components/auth_frame/auth_frame.dart';
import '../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import 'components/email_is_confirmed_text.dart';
import 'components/success_text.dart';

class EmailVerificationSuccess extends HookWidget {
  const EmailVerificationSuccess({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigatorKey = useProvider(navigatorKeyPod);
    final authorized = useProvider(authorizedStpod);
    final authInfo = useProvider(authInfoNotipod);

    return ProviderListener<int>(
      provider: timerNotipod(3),
      onChange: (context, value) {
        if (value == 0) {
          authorized.state = const Home();
          navigateToRouter(navigatorKey);
        }
      },
      child: AuthFrame(
        header: 'Email Verification',
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Icon(
                FontAwesomeIcons.checkCircle,
                size: 125.w,
              ),
              const SpaceH30(),
              const SuccessText(),
              const SpaceH15(),
              EmailIsConfirmedText(
                email: authInfo.email,
              ),
              const Spacer(),
              LinearProgressIndicator(
                minHeight: 8.h,
                color: Colors.grey,
                backgroundColor: const Color(0xffeeeeee),
              )
            ],
          ),
        ),
      ),
    );
  }
}
