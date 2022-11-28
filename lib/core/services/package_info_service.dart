import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  Future<PackageInfoService> init() async {
    info = await PackageInfo.fromPlatform();

    return this;
  }

  var info = PackageInfo(
    appName: 'unknown',
    packageName: 'unknown',
    version: 'unknown',
    buildNumber: 'unknown',
  );
}
