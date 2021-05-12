import 'package:dio/dio.dart';

import '../dto/login_dto.dart';
import '../dto/register_dto.dart';
import 'services/login_service.dart';
import 'services/regiser_service.dart';

class AuthService {
  static Future<Response<dynamic>> register(RegisterDto dto) {
    return registerService(dto);
  }

  static Future<Response<dynamic>> login(LoginDto dto) async {
    return loginService(dto);
  }
}
