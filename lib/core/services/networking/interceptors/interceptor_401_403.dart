import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/authentication/authentication_service.dart';
import 'package:jetwallet/core/services/networking/helpers/retry_request.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';

Future<void> interceptor401_403({
  required DioError dioError,
  required ErrorInterceptorHandler handler,
}) async {
  try {
    final result = await refreshToken();

    final authModel = getIt.get<AuthenticationService>().authState;

    if (result == RefreshTokenStatus.success) {
      final response = await retryRequest(
        dioError.requestOptions,
        authModel.token,
      );
      handler.resolve(response);
    } else {
      handler.reject(dioError);
    }
  } catch (_) {
    handler.reject(dioError);
  }
}
