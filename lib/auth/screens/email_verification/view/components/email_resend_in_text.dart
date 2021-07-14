import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/providers/service_providers.dart';

class EmailResendInText extends HookWidget {
  const EmailResendInText({
    Key? key,
    required this.seconds,
  }) : super(key: key);

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Center(
      child: Text(
        '${intl.youCanResendIn} $seconds ${intl.seconds.toLowerCase()}',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 15.sp,
        ),
      ),
    );
  }
}
