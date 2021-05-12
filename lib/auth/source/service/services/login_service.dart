import 'package:dio/dio.dart';

import '../../../../shared/constants/source.dart';
import '../../dto/login_dto.dart';

Future<Response<dynamic>> loginService(LoginDto dto) async {
  final _dio = Dio();

  final response = await _dio.post(
    '$tradingAuthBaseUrl/Trader/Authenticate',
    data: dto.toJson(),
  );

  return response;
}
