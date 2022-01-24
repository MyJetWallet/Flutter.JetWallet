import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../helpers/device_type.dart';
import '../../providers/device_size/media_query_pod.dart';
import '../../providers/device_uid_pod.dart';
import '../../providers/package_info_fpod.dart';
import '../../providers/service_providers.dart';

void setupHeaders(Dio dio, Reader read, [String? token]) {
  final locale = read(intlPod).localeName;
  final deviceUid = read(deviceUidPod);
  final appVersion = read(packageInfoPod).version;
  final mediaQuery = read(mediaQueryStpod).state!;
  final deviceSize = mediaQuery.size;
  final devicePixelRatio = mediaQuery.devicePixelRatio;

  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer $token';
  dio.options.headers['Accept-Language'] = locale;
  dio.options.headers['From'] = deviceUid;
  dio.options.headers['User-Agent'] =
      '$appVersion;$deviceType;$deviceSize;$devicePixelRatio';
}
