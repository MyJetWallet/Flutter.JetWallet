import 'package:dio/dio.dart';

import '../../../../shared/constants/source.dart';
import '../../dto/authentication/register_request_dto.dart';

Future<Response<dynamic>> registerService(RegisterRequestDto dto) async {
  final _dio = Dio();

  final response = await _dio.post(
    '$tradingAuthBaseUrl/Trader/Register',
    data: dto.toJson(),
  );

  return response;
}
