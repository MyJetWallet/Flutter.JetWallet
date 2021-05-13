import 'package:dio/dio.dart';

import '../../../../shared/constants/source.dart';
import '../../dto/authorization/authorization_request_dto.dart';

Future<Response<dynamic>> authorizationService(
    AuthorizationRequestDto dto) async {
  final _dio = Dio();

  final response = await _dio.post(
    '$tradingAuthBaseUrl/authorization/authorization',
    data: dto.toJson(),
  );

  return response;
}
