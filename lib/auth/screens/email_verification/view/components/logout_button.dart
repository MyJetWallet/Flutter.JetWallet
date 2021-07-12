import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/notifiers/logout_notifier/logout_notipod.dart';

class LogoutButton extends HookWidget {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logoutN = useProvider(logoutNotipod.notifier);

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => logoutN.logout(),
      child: Padding(
        padding: EdgeInsets.only(
          top: 6.h,
          bottom: 6.h,
          right: 10.w,
        ),
        child: Icon(
          Icons.arrow_back,
          size: 22.r,
        ),
      ),
    );
  }
}
