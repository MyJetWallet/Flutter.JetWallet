import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/utils/helpers/device_helper.dart';

String getUserAgent() {
  final deviceInfo = sDeviceInfo.model;
  final deviceSize = sDeviceSize;
  final packageInfo = getIt.get<PackageInfoService>().info;
  final appVersion = packageInfo.version;
  final devicePixelRatio = '123'; // TODO: refactor
  //MediaQuery.of(sRouter.navigatorKey.currentContext!);

  return '$appVersion;${packageInfo.buildNumber};$deviceType;$deviceSize;'
      '$devicePixelRatio;${deviceInfo.marketingName}';
}
