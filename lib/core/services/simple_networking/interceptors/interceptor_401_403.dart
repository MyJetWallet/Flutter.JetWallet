import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/retry_request.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';

Future<void> interceptor401_403({
  required DioError dioError,
  required ErrorInterceptorHandler handler,
}) async {
  try {
    print('INTERCEPTOR 401');

    final result = await refreshToken();

    print('INTERCEPTOR 401: $result');

    final authModel = getIt.get<AppStore>().authState;

    if (result == RefreshTokenStatus.success) {
      final response = await retryRequest(
        dioError.requestOptions,
        authModel.token,
      );
      handler.resolve(response);
    } else {
      handler.reject(dioError);
      await getIt.get<LogoutService>().logout('INTERCEPTOR, cant update token');
    }
  } catch (_) {
    handler.reject(dioError);
  }
}
