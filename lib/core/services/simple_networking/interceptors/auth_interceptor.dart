import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/rsa_service.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/retry_request.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/setup_headers.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';

void setAuthInterceptor(
  Dio dio, {
  required bool isImage,
}) {
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.method == postRequest) {
          ///make private
          final requestBody = options.data;

          final rsaService = getIt.get<RsaService>();
          final storageService = getIt.get<LocalStorageService>();

          final privateKey = await storageService.getValue(privateKeyKey);
          final signature = privateKey != null
              ? rsaService.sign(
                  jsonEncode(requestBody),
                  privateKey,
                )
              : '';
          options.headers[signatureHeader] = signature;
        }

        final authModel = getIt.get<AppStore>().authState;

        if (authModel.token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer ${authModel.token}';
        } else {
          /// We dont hava token, so we can't send the request
          handler.reject(
            DioError(
              requestOptions: options,
            ),
          );

          return;
        }

        options = setHeaders(options, isImage);

        return handler.next(options);
      },
      onError: (dioError, handler) async {
        final code = dioError.response?.statusCode;

        if (code == 401 || code == 403) {
          try {
            final result = await refreshToken();

            if (result == RefreshTokenStatus.success) {
              final response = await retryRequest(
                dioError.requestOptions,
              );

              handler.resolve(response);
            } else {
              handler.reject(dioError);
              await getIt.get<LogoutService>().logout(
                    'INTERCEPTOR, cant update token',
                  );
            }
          } catch (_) {
            handler.reject(dioError);
          }
        } else {
          handler.reject(dioError);
        }
      },
    ),
  );
}
