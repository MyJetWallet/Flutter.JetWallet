import 'package:dio/dio.dart';

import '../dto/authentication/login_request_dto.dart';
import '../dto/authentication/register_request_dto.dart';
import '../dto/authorization/authorization_request_dto.dart';
import 'services/authorization_service.dart';
import 'services/login_service.dart';
import 'services/logout_service.dart';
import 'services/regiser_service.dart';

class AuthService {
  static Future<Response> register(RegisterRequestDto dto) {
    return registerService(dto);
  }

  static Future<Response> login(LoginRequestDto dto) {
    return loginService(dto);
  }

  static Future<Response> logout() {
    return logoutService();
  }

  static Future<Response> authorize(AuthorizationRequestDto dto) {
    return authorizationService(dto);
  }
}
