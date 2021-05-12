import '../../model/auth_model.dart';
import '../../model/login_model.dart';
import '../../model/register_model.dart';
import 'repositories/login_repository.dart';
import 'repositories/register_repository.dart';

class AuthRepository {
  static Future<AuthModel> register(RegisterModel model) async {
    return registerRepository(model);
  }

  static Future<AuthModel> login(LoginModel model) async {
    return loginRepository(model);
  }
}
