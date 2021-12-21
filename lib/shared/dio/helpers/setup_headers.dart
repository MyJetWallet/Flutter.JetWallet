import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../helpers/device_type.dart';
import '../../providers/device_uid_pod.dart';
import '../../providers/package_info_fpod.dart';
import '../../providers/service_providers.dart';

void setupHeaders(Dio dio, Reader read, [String? token]) {
  dio.options.headers['accept'] = 'application/json';
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers['Authorization'] = 'Bearer $token';
  dio.options.headers['Accept-Language'] = read(intlPod).localeName;
  dio.options.headers['From'] = read(deviceUidPod);
  dio.options.headers['User-Agent'] = '${read(appVersionPod)};$deviceType()';
}
