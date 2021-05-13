import '../../../../shared/source/helpers/handle_response_codes.dart';
import '../../../model/authorization/authorization_request_model.dart';
import '../../../model/authorization/authorization_response_model.dart';
import '../../dto/authorization/authorization_request_dto.dart';
import '../../dto/authorization/authorization_response_dto.dart';
import '../../service/auth_service.dart';

Future<AuthorizationResponseModel> authorizationRepository(
  AuthorizationRequestModel requestModel,
) async {
  final requestDto = AuthorizationRequestDto.fromModel(requestModel);
  
  final response = await AuthService.authorize(requestDto);

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = AuthorizationResponseDto.fromJson(responseData);

  handleResponseCodes(responseDto.responseCodes);

  return responseDto.toModel();
}
