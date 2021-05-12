import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../global/const.dart';
import 'model/common_response.dart';

class DioClient extends Interceptor {
  DioClient() {
    _dio = Dio();
    _dio.interceptors.addAll(
        [this, PrettyDioLogger(requestBody: true, requestHeader: true)]);
    _dio.options = BaseOptions(
      headers: {
        'accept': 'application/json',
        'Content-type': 'application/json',
      },
    );
  }

  late Dio _dio;
  String? token;

  Future<CommonResponse> get(String url) async {
    try {
      final response = await _dio.get(url);
      final commonResponse = CommonResponse.fromJson(response.data);

      return commonResponse;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return CommonResponse(unauthorizedError, null);
      } else {
        return CommonResponse(baseError, null);
      }
    }
  }

  Future<CommonResponse> post(String url, {Map<String, dynamic>? body}) async {
    try {
      final response = await _dio.post(url, data: body);
      final commonResponse = CommonResponse.fromJson(response.data);

      return commonResponse;
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        return CommonResponse(unauthorizedError, null);
      } else {
        return CommonResponse(baseError, null);
      }
    }
  }

  //TODO(Vova): Add refresh action on 401/403 responses
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer ${token ?? ''}';
    return super.onRequest(options, handler);
  }
}
