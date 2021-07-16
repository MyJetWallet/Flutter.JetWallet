import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../provider/package_info_fpod.dart';

class AppVersionText extends HookWidget {
  const AppVersionText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final package = useProvider(packageInfoFpod);

    return Center(
      child: Text(
        '${intl.jetWalletAppVersion} ${package.maybeWhen(
          data: (data) => "${data.version}:${data.buildNumber}",
          orElse: () => "1.0.0",
        )}',
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: TextStyle(
          fontWeight: FontWeight.w300,
          letterSpacing: 0.42.w,
          color: Colors.grey,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}
