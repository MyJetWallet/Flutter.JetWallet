import 'package:dio/dio.dart';

import '../../../model/auth_model.dart';
import '../../../model/authentication/login_request_model.dart';
import '../../dto/auth_response_dto.dart';
import '../../dto/authentication/login_request_dto.dart';
import '../../service/auth_service.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthModel> loginRepository(LoginRequestModel requestModel) async {
  try {
    final requestDto = LoginRequestDto.fromModel(requestModel);

    final response = await AuthService.login(requestDto);

    final responseData = response.data as Map<String, dynamic>;

    final authResponse = AuthResponseDto.fromJson(responseData);

    return handleAuthResponse(authResponse);
  } on DioError catch (e) {
    throw e.message;
  }
}
