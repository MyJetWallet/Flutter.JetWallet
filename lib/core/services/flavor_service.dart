import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/features/app/store/app_store.dart';

enum Flavor {
  prod,
  stage,
  dev,
}

Flavor flavorService() {
  final env = getIt<AppStore>().env;

  if (env == 'prod') {
    return Flavor.prod;
  } else if (env == 'stage') {
    return Flavor.stage;
  } else {
    return Flavor.dev;
  }

  // old TODO: Временный костыль или нет (?) для демки
  /*final packageInfo = getIt.get<PackageInfoService>().info;

  if (packageInfo.packageName == 'app.simple.com') {
    return Flavor.prod;
  } else if (packageInfo.packageName == 'stage.app.simple.com') {
    return Flavor.stage;
  } else {
    return Flavor.dev;
  }*/
}
