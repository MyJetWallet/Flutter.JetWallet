import 'package:dio/dio.dart';

import '../../../../shared/constants/source.dart';

Future<Response<dynamic>> logoutService() async {
  final _dio = Dio();

  final response = await _dio.post(
    '$walletApiBaseUrl/authorization/logout',
  );

  return response;
}
