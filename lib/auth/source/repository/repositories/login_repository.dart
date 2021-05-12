import 'package:dio/dio.dart';

import '../../../model/auth_model.dart';
import '../../../model/login_model.dart';
import '../../dto/auth_response_dto.dart';
import '../../dto/login_dto.dart';
import '../../service/auth_service.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthModel> loginRepository(LoginModel loginModel) async {
  try {
    final loginDto = LoginDto.fromModel(loginModel);

    final response = await AuthService.login(loginDto);

    final responseData = response.data as Map<String, dynamic>;

    final authResponse = AuthResponseDto.fromJson(responseData);

    return handleAuthResponse(authResponse);
  } on DioError catch (e) {
    throw e.message;
  }
}
