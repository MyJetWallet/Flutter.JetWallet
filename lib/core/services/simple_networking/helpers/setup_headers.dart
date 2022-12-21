import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/utils/helpers/device_helper.dart';
import 'package:jetwallet/utils/helpers/get_user_agent.dart';

RequestOptions setHeaders(RequestOptions options, bool isImage) {
  final locale = intl.localeName;
  final deviceInfo = getIt.get<DeviceInfo>().model;

  options.headers['accept'] = 'application/json';
  options.headers['Accept-Language'] = locale;
  options.headers['From'] = deviceInfo.deviceUid;
  options.headers['User-Agent'] = getUserAgent();

  if (isImage) {
    options.headers['Content-Type'] = 'multipart/form-data';
  } else {
    options.headers['content-Type'] = 'application/json';
  }

  return options;
}

/*
void setupHeaders(Dio dio, [String? token]) {
  final locale = intl.localeName;
  final deviceInfo = getIt.get<DeviceInfo>().model;
  final packageInfo = getIt.get<PackageInfoService>().info;
  final appVersion = packageInfo.version;

  MediaQueryData? mediaQuery;
  Size deviceSize = const Size(0, 0);
  double devicePixelRatio = 0.0;

  if (sRouter.navigatorKey.currentContext != null) {
    mediaQuery = MediaQuery.of(sRouter.navigatorKey.currentContext!);

    deviceSize = mediaQuery.size;
    devicePixelRatio = mediaQuery.devicePixelRatio;
  }

  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer $token';
  dio.options.headers['Accept-Language'] = locale;
  dio.options.headers['From'] = deviceInfo.deviceUid;
  dio.options.headers['User-Agent'] = getUserAgent();

  /// Also change user agent for SignalR
}
*/