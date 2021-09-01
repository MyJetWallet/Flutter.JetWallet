import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/helpers/navigate_to_router.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/providers/other/navigator_key_pod.dart';
import '../components/result_frame.dart';
import '../components/result_icon.dart';

class SuccessScreen extends HookWidget {
  const SuccessScreen({
    Key? key,
    this.header,
    required this.description,
  }) : super(key: key);

  final String? header;
  final String description;

  @override
  Widget build(BuildContext context) {
    final navigatorKey = useProvider(navigatorKeyPod);

    return ProviderListener<int>(
      provider: timerNotipod(2),
      onChange: (context, value) {
        if (value == 0) navigateToRouter(navigatorKey);
      },
      child: ResultFrame(
        header: header,
        resultIcon: const ResultIcon(
          FontAwesomeIcons.checkCircle,
        ),
        title: 'Success',
        description: description,
        children: [
          LinearProgressIndicator(
            minHeight: 8.h,
            color: Colors.grey,
            backgroundColor: const Color(0xffeeeeee),
          )
        ],
      ),
    );
  }
}
