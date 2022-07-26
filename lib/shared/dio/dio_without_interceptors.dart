import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/flavor_pod.dart';
import 'helpers/add_logger.dart';
import 'helpers/add_proxy.dart';
import 'helpers/setup_headers.dart';

Dio dioWithoutInterceptors(Reader read) {
  final dio = Dio();

  setupHeaders(dio, read);

  if (read(flavorPod) == Flavor.dev) {
    addLogger(dio);
  }

  addProxy(dio, read);

  return dio;
}
