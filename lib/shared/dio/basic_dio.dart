import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../auth/screens/sign_in_up/model/auth_model.dart';
import 'helpers/add_interceptors.dart';
import 'helpers/add_logger.dart';
import 'helpers/setup_headers.dart';

Dio basicDio(AuthModel authModel, Reader read) {
  final _dio = Dio();

  setupHeaders(_dio, authModel.token);

  addLogger(_dio);

  addInterceptors(_dio, read);

  return _dio;
}
