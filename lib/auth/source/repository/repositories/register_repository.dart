import '../../../model/auth_model.dart';
import '../../../model/authentication/register_request_model.dart';
import '../../dto/auth_response_dto.dart';
import '../../dto/authentication/register_request_dto.dart';
import '../../service/auth_service.dart';
import '../helpers/handle_auth_response.dart';

Future<AuthModel> registerRepository(RegisterRequestModel registerModel) async {
  final registerDto = RegisterRequestDto.fromModel(registerModel);

  final response = await AuthService.register(registerDto);

  final responseData = response.data as Map<String, dynamic>;

  final authResponse = AuthResponseDto.fromJson(responseData);

  return handleAuthResponse(authResponse);
}
