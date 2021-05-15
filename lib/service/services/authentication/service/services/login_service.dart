import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../authentication/dto/authentication_response_dto.dart';
import '../../../authentication/dto/login_request_dto.dart';
import '../../model/authentication_model.dart';
import '../../model/login_request_model.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthenticationModel> loginService(
  Dio dio,
  LoginRequestModel model,
) async {
  final requestDto = LoginRequestDto.fromModel(model);

  final response = await dio.post(
    '$tradingAuthBaseUrl/Trader/Authenticate',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = AuthenticationResponseDto.fromJson(responseData);

  return handleAuthResponse(responseDto);
}
