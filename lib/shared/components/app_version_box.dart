import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_kit/simple_kit.dart';

import '../providers/package_info_fpod.dart';

class AppVersionBox extends HookWidget {
  const AppVersionBox({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final packageInfo = useProvider(packageInfoFpod);
    final colors = useProvider(sColorPod);

    return packageInfo.when(
      data: (PackageInfo info) {
        return Container(
          padding: EdgeInsets.symmetric(
            vertical: 4.h,
            horizontal: 10.h,
          ),
          decoration: BoxDecoration(
            color: colors.grey5,
            borderRadius: BorderRadius.circular(16.r),
          ),
          alignment: Alignment.center,
          height: 26.h,
          child: Text(
            'Version: ${info.version} (${info.buildNumber})',
            style: sCaptionTextStyle.copyWith(
              color: colors.grey1,
            ),
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}
