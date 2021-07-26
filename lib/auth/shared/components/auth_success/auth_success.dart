import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/page_frame/page_frame.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/helpers/navigate_to_router.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/providers/other/navigator_key_pod.dart';
import 'components/success_description_text.dart';
import 'components/success_text.dart';

class AuthSuccess extends HookWidget {
  const AuthSuccess({
    Key? key,
    required this.header,
    required this.description,
  }) : super(key: key);

  final String header;
  final String description;

  @override
  Widget build(BuildContext context) {
    final navigatorKey = useProvider(navigatorKeyPod);

    return ProviderListener<int>(
      provider: timerNotipod(3),
      onChange: (context, value) {
        if (value == 0) navigateToRouter(navigatorKey);
      },
      child: PageFrame(
        header: header,
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
            SuccessDescriptionText(
              text: description,
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
    );
  }
}
