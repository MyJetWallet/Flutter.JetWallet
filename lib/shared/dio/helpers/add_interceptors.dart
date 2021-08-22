import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../interceptors/interceptor_401_403.dart';

void addInterceptors(Dio dio, Reader read) {
  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (dioError, handler) async {
        dio.lock();

        final code = dioError.response?.statusCode;

        if (code == 401 || code == 403) {
          await interceptor401_403(
            dioError: dioError,
            handler: handler,
            read: read,
          );
        } else {
          handler.reject(dioError);
        }

        dio.unlock();
      },
    ),
  );
}
