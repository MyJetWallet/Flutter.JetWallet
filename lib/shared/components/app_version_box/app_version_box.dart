import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/shared/features/about_us/provider/package_info_fpod.dart';
import 'components/app_version_in_container.dart';

class AppVersionBox extends HookWidget {
  const AppVersionBox({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final packageInfo = useProvider(packageInfoFpod);

    return packageInfo.when(
      data: (PackageInfo info) {
        return AppVersionInContainer(
          versionText: 'Version: ${info.version} (${info.buildNumber})',
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}
