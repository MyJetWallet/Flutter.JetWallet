import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/package_info_service.dart';

enum Flavor {
  prod,
  stage,
  dev,
}

Flavor flavorService() {
  final packageInfo = getIt.get<PackageInfoService>().info;

  if (packageInfo.packageName == 'app.simple.com') {
    return Flavor.prod;
  } else if (packageInfo.packageName == 'stage.app.simple.com') {
    return Flavor.stage;
  } else {
    return Flavor.dev;
  }
}
