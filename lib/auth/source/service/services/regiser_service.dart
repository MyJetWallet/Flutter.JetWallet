import 'package:dio/dio.dart';

import '../../../../shared/constants/source.dart';
import '../../dto/register_dto.dart';

Future<Response<dynamic>> registerService(RegisterDto dto) async {
  final _dio = Dio();

  final response = await _dio.post(
    '$tradingAuthBaseUrl/Trader/Register',
    data: dto.toJson(),
  );

  return response;
}
