import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/helpers/open_email_app.dart';

class OpenEmailAppButton extends HookWidget {
  const OpenEmailAppButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openEmailApp(context),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: 140.w,
        height: 26.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.5.w,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            'Open email app',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
