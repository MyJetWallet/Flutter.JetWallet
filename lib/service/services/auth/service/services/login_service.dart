import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../dto/authentication/auth_response_dto.dart';
import '../../dto/authentication/login_request_dto.dart';
import '../../model/authentication/auth_model.dart';
import '../../model/authentication/login_request_model.dart';
import '../helpers/handle_auth_response.dart';


Future<AuthModel> loginService(LoginRequestModel model) async {
  final _dio = Dio();

  try {
    final requestDto = LoginRequestDto.fromModel(model);

    final response = await _dio.post(
      '$tradingAuthBaseUrl/Trader/Authenticate',
      data: requestDto.toJson(),
    );

    final responseData = response.data as Map<String, dynamic>;

    final responseDto = AuthResponseDto.fromJson(responseData);

    return handleAuthResponse(responseDto);
  } on DioError catch (e) {
    throw e.message;
  }
}
