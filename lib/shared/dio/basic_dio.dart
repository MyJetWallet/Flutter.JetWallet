import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/shared/notifiers/auth_info_notifier/auth_info_state.dart';
import 'helpers/add_interceptors.dart';
import 'helpers/add_logger.dart';
import 'helpers/add_signing.dart';
import 'helpers/setup_headers.dart';

Dio basicDio(AuthInfoState authModel, Reader read) {
  final _dio = Dio();

  setupHeaders(_dio, authModel.token);

  addSigning(_dio, read);

  addLogger(_dio);

  addInterceptors(_dio, read);

  return _dio;
}
