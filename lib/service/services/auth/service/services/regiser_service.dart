import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../dto/authentication/auth_response_dto.dart';
import '../../dto/authentication/register_request_dto.dart';
import '../../model/authentication/auth_model.dart';
import '../../model/authentication/register_request_model.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthModel> registerService(RegisterRequestModel model) async {
  final _dio = Dio();

  final requestDto = RegisterRequestDto.fromModel(model);

  final response = await _dio.post(
    '$tradingAuthBaseUrl/Trader/Register',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = AuthResponseDto.fromJson(responseData);

  return handleAuthResponse(responseDto);
}
