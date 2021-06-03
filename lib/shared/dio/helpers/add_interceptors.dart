import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../interceptors/interceptor_401.dart';

void addInterceptors(Dio dio, Reader read) {
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (dioError, handler) async {
        dio.lock();

        if (dioError.response?.statusCode == 401) {
          await interceptor401(
            dioError: dioError,
            handler: handler,
            read: read,
          );
        } else if (dioError.response?.statusCode == 403) {
          // todo add interceptor403()
        } else {
          handler.reject(dioError);
        }

        dio.unlock();
      },
    ),
  );
}
