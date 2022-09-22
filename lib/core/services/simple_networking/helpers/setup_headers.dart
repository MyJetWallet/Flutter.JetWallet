import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/utils/helpers/device_helper.dart';

void setupHeaders(Dio dio, [String? token]) {
  final locale = intl.localeName;
  final deviceInfo = getIt.get<DeviceInfo>().model;
  final packageInfo = getIt.get<PackageInfoService>().info;
  final appVersion = packageInfo.version;

  final mediaQuery = MediaQuery.of(sRouter.navigatorKey.currentContext!);

  final deviceSize = mediaQuery.size;
  final devicePixelRatio = mediaQuery.devicePixelRatio;

  final lang = intl.localeName;

  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer $token';
  dio.options.headers['Accept-Language'] = locale;
  dio.options.headers['From'] = deviceInfo.deviceUid;
  dio.options.headers['User-Agent'] =
      '$appVersion;${packageInfo.buildNumber};$deviceType;$deviceSize;'
      '$devicePixelRatio;${deviceInfo.marketingName};$lang';
}
