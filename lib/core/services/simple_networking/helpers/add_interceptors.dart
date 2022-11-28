import 'package:dio/dio.dart';

import '../interceptors/interceptor_401_403.dart';

void addInterceptors(
  Dio dio,
) {
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onError: (dioError, handler) async {
        final code = dioError.response?.statusCode;

        if (code == 401 || code == 403) {
          await interceptor401_403(
            dioError: dioError,
            handler: handler,
          );
        } else {
          handler.reject(dioError);
        }
      },
    ),
  );
}
