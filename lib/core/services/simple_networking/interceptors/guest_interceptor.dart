import 'package:dio/dio.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/setup_headers.dart';

void setGuestInterceptor(
  Dio dio,
) {
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        options = await setHeaders(options, false);

        return handler.next(options);
      },
    ),
  );
}
