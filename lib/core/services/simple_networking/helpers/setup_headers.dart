import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/package_info_service.dart';
import 'package:jetwallet/utils/helpers/device_helper.dart';
import 'package:jetwallet/utils/helpers/get_user_agent.dart';

Future<RequestOptions> setHeaders(RequestOptions options, bool isImage) async {
  final locale = intl.localeName;
  final deviceInfo = getIt.get<DeviceInfo>().model;

  options.headers['accept'] = 'application/json';
  options.headers['Accept-Language'] = locale;
  options.headers['From'] = deviceInfo.deviceUid;
  options.headers['User-Agent'] = await getUserAgent();

  if (isImage) {
    options.headers['Content-Type'] = 'multipart/form-data';
  } else {
    options.headers['content-Type'] = 'application/json';
  }

  return options;
}