import '../../../model/auth_model.dart';
import '../../../model/register_model.dart';
import '../../dto/auth_response_dto.dart';
import '../../dto/register_dto.dart';
import '../../service/auth_service.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthModel> registerRepository(RegisterModel registerModel) async {
  final registerDto = RegisterDto.fromModel(registerModel);

  final response = await AuthService.register(registerDto);

  final responseData = response.data as Map<String, dynamic>;

  final authResponse = AuthResponseDto.fromJson(responseData);

  return handleAuthResponse(authResponse);
}
