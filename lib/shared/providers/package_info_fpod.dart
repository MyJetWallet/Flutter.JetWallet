import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoFpod = FutureProvider<PackageInfo>(
  (ref) {
    return PackageInfo.fromPlatform();
  },
  name: '_packageInfoFpod',
);

final appVersionPod = Provider<String>(
  (ref) {
    var version = '';

    ref.watch(packageInfoFpod).whenData((value) {
      version = value.version;
    });

    return version;
  },
  name: 'appVersionPod',
);
