import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../auth/providers/auth_model_notipod.dart';
import '../../helpers/refresh_token.dart';
import '../helpers/retry_request.dart';

Future<void> interceptor401({
  required DioError dioError,
  required ErrorInterceptorHandler handler,
  required Reader read,
}) async {
  try {
    final result = await refreshToken(read);

    final authModel = read(authModelNotipod);

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
