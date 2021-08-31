import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../service/shared/constants.dart';
import '../../providers/service_providers.dart';
import '../../services/local_storage_service.dart';

void addSigning(Dio dio, Reader read) {
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        dio.lock();

        if (options.method == postRequest) {
          final requestBody = options.data;

          final rsaService = read(rsaServicePod);
          final storageService = read(localStorageServicePod);

          final privateKey = await storageService.getString(privateKeyKey);
          final signature = privateKey != null
              ? await rsaService.sign(
                  jsonEncode(requestBody),
                  privateKey,
                )
              : '';
          options.headers[signatureHeader] = signature;
        }

        dio.unlock();

        return handler.next(options);
      },
    ),
  );
}
