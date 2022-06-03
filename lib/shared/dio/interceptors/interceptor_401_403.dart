import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/shared/models/refresh_token_status.dart';

import '../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../helpers/refresh_token.dart';
import '../helpers/retry_request.dart';

Future<void> interceptor401_403({
  required DioError dioError,
  required ErrorInterceptorHandler handler,
  required Reader read,
}) async {
  try {
    final result = await refreshToken(read);

    final authModel = read(authInfoNotipod);

    if (result == RefreshTokenStatus.success) {
      final response = await retryRequest(
        dioError.requestOptions,
        read,
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
