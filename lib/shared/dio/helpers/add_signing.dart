import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants.dart';
import '../../providers/service_providers.dart';
import '../../services/local_storage_service.dart';

void addSigning(Dio dio, Reader read) {
  dio.interceptors.add(
    QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        if (options.method == postRequest) {
          final requestBody = options.data;

          final rsaService = read(rsaServicePod);
          final storageService = read(localStorageServicePod);

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
