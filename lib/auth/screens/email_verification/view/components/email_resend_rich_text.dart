import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';

class EmailResendRichText extends HookWidget {
  const EmailResendRichText({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);

    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 15.sp,
            color: Colors.grey,
          ),
          children: [
            TextSpan(
              text: '${intl.didntReceiveTheCode} ',
            ),
            TextSpan(
              text: intl.resend,
              recognizer: TapGestureRecognizer()..onTap = onTap,
              style: const TextStyle(
                color: Colors.black54,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
