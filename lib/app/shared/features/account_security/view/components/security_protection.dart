import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../helper/protection_level.dart';

class SecurityProtection extends HookWidget {
  const SecurityProtection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoNotipod);
    final level = protectionLevel(userInfo);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shield,
            size: 46.r,
            color: level.color,
          ),
          const SpaceH10(),
          Text(
            '${level.name} protection level',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
