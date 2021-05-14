import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_response_codes.dart';
import '../../dto/authorization/authorization_request_dto.dart';
import '../../dto/authorization/authorization_response_dto.dart';
import '../../model/authorization/authorization_request_model.dart';
import '../../model/authorization/authorization_response_model.dart';

Future<AuthorizationResponseModel> authorizationService(
  AuthorizationRequestModel model,
) async {
  final _dio = Dio();

  final requestDto = AuthorizationRequestDto.fromModel(model);

  final response = await _dio.post(
    '$tradingAuthBaseUrl/authorization/authorization',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = AuthorizationResponseDto.fromJson(responseData);

  handleResponseCodes(responseDto.responseCodes);

  return responseDto.toModel();
}
