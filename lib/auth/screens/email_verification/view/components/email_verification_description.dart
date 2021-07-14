import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../../sign_in_up/notifier/auth_model_notifier/auth_model_notipod.dart';

class EmailVerificationDescription extends HookWidget {
  const EmailVerificationDescription({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final authModel = useProvider(authModelNotipod);

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: '${intl.enterTheCodeWeHaveSentYouToYourEmail} ',
          ),
          TextSpan(
            text: authModel.email,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
