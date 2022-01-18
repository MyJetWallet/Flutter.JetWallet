import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoFpod = FutureProvider<PackageInfo>(
  (ref) {
    return PackageInfo.fromPlatform();
  },
  name: '_packageInfoFpod',
);

final packageInfoPod = Provider<PackageInfo>(
  (ref) {
    var info = PackageInfo(
      appName: 'unknown',
      packageName: 'unknown',
      version: 'unknown',
      buildNumber: 'unknown',
    );

    ref.watch(packageInfoFpod).whenData((value) {
      info = value;
    });

    return info;
  },
  name: 'packageInfoPod',
);
