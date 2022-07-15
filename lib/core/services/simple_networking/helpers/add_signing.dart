import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/rsa_service.dart';
import 'package:jetwallet/utils/constants.dart';

void addSigning(Dio dio) {
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.method == postRequest) {
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

        return handler.next(options);
      },
    ),
  );
}
