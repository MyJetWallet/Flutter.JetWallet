import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../authentication/dto/authentication_response_dto.dart';
import '../../../authentication/dto/register_request_dto.dart';
import '../../model/authentication_model.dart';
import '../../model/register_request_model.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthenticationModel> registerService(
  Dio dio,
  RegisterRequestModel model,
) async {
  final requestDto = RegisterRequestDto.fromModel(model);

  final response = await dio.post(
    '$tradingAuthBaseUrl/Trader/Register',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = AuthenticationResponseDto.fromJson(responseData);

  return handleAuthResponse(responseDto);
}
