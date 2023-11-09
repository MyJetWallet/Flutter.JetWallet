import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/rsa_service.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/retry_request.dart';
import 'package:jetwallet/core/services/simple_networking/helpers/setup_headers.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:logger/logger.dart' as log_print;
import 'package:simple_networking/helpers/models/refresh_token_status.dart';

void setAuthInterceptor(
  Dio dio, {
  required bool isImage,
}) {
  final log = log_print.Logger();

  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.extra.containsKey('sessionID')) {
          if (getIt<AppStore>().sessionID != options.extra['sessionID']) {
            log.e(
              '''AUTH INTERCEPTOR: SESSION ID NOR COMPARE \n AppStore: ${getIt<AppStore>().sessionID} \n User: ${options.extra["sessionID"]}''',
            );

            handler.reject(
              DioError(
                requestOptions: options,
              ),
            );

            return;
          }
        }

        if (!isImage) {
          options = await _addSignature(options);
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
        if (options.extra.containsKey('isSensitive') && options.extra['isSensitive'] == 'sensitive') {
          options.headers['Authorization'] = 'Bearer M8/SmRtqXrqe+H2XH6lRM30YrIIeOWlQc/Zq9lSH9JSodskVfJ5LFejjAeZxX9CWGTZKn9oTV8AOEFQnP/Vx0XL/tniS5jvi9EISqPqbwbos0oxw9edNcloi+7xFRxb619r9NUUnCIQpOWeow4j5I95VwyuGTfSegVuFLm5mfAw=';
        }

        options = await setHeaders(options, isImage);

        return handler.next(options);
      },
      onError: (dioError, handler) async {

        print('dioError');
        print(dioError);
        print(dioError.error);
        print(dioError.message);
        print(dioError.requestOptions.data);
        print(dioError.requestOptions.path);
        print(dioError.requestOptions.baseUrl);
        print(dioError.requestOptions.headers);
        print(dioError.response);
        if (getIt.isRegistered<AppStore>()) {
          if (getIt<AppStore>().appStatus == AppStatus.end) {
            handler.reject(dioError);

            return;
          }
        }

        log.e(
          '''AUTH INTERCEPTOR: ${dioError.response}\nAppStore: ${getIt<AppStore>().appStatus}''',
        );

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
                    callbackAfterSend: () {},
                  );
            }
          } catch (_) {
            handler.reject(dioError);
          }
        } else if (code == 500 || code == 504) {
          sNotification.showError(
            intl.something_went_wrong_try_again,
            id: 1,
          );

          handler.reject(dioError);
        } else {
          handler.reject(dioError);
        }
      },
    ),
  );
}

Future<RequestOptions> _addSignature(RequestOptions options) async {
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

  return options;
}
