import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package_info_fpod.dart';

enum Flavor {
  prod,
  stage,
  dev,
}

final flavorPod = Provider<Flavor>(
  (ref) {
    final packageInfo = ref.read(packageInfoPod);

    if (packageInfo.packageName == 'app.simple.com') {
      return Flavor.prod;
    } else if (packageInfo.packageName == 'stage.app.simple.com') {
      return Flavor.stage;
    } else {
      return Flavor.dev;
    }
  },
  name: 'flavorPod',
);
