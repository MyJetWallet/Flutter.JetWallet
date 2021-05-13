import '../../../../shared/source/dto/reponse_codes_dto.dart';
import '../../../../shared/source/helpers/handle_response_codes.dart';
import '../../service/auth_service.dart';

Future<void> logoutRepository() async {
  final response = await AuthService.logout();

  final responseData = response.data as Map<String, dynamic>;

  final responseCodes = ResponseCodesDto.fromJson(responseData);

  handleResponseCodes(responseCodes);
}
