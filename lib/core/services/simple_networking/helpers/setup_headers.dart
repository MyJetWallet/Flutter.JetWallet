import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';

void setupHeaders(Dio dio, [String? token]) {
  final locale = intl.localeName;
  final deviceInfo = getIt.get<DeviceInfo>().model;
  final appVersion = 'test';

  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer $token';
  dio.options.headers['Accept-Language'] = locale;
  dio.options.headers['From'] = deviceInfo.deviceUid;
  dio.options.headers['User-Agent'] =
      '$appVersion;${182};${deviceInfo.marketingName}';
}
