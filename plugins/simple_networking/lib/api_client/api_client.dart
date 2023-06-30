import 'package:dio/dio.dart';
import 'package:simple_networking/simple_networking.dart';

class ApiClient {
  ApiClient(this.dio, this.options, this.sessionID);

  final Dio dio;
  final SimpleOptions options;
  final String? sessionID;

  Future<Response> post(
    String path, {
    dynamic data,
  }) async {
    return await dio
        .post(
          path,
          data: data,
          options: sessionID != null || (sessionID?.isEmpty ?? false)
              ? Options(
                  extra: {
                    'sessionID': sessionID,
                  },
                )
              : null,
        )
        .timeout(const Duration(seconds: 60));
  }

  Future<Response> put(
    String path, {
    dynamic data,
  }) async {
    return await dio
        .put(
          path,
          data: data,
          options: sessionID != null || (sessionID?.isEmpty ?? false)
              ? Options(
                  extra: {
                    'sessionID': sessionID,
                  },
                )
              : null,
        )
        .timeout(const Duration(seconds: 60));
  }

  Future<Response> delete(
    String path, {
    dynamic data,
  }) async {
    return await dio
        .delete(
          path,
          data: data,
          options: sessionID != null || (sessionID?.isEmpty ?? false)
              ? Options(
                  extra: {
                    'sessionID': sessionID,
                  },
                )
              : null,
        )
        .timeout(const Duration(seconds: 60));
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio
        .get(
          path,
          queryParameters: queryParameters,
          options: sessionID != null
              ? Options(
                  extra: {
                    'sessionID': sessionID,
                  },
                )
              : null,
        )
        .timeout(const Duration(seconds: 60));
  }
}
