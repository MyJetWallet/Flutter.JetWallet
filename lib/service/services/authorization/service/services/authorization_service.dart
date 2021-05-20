import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_response_codes.dart';
import '../../../authorization/dto/authorization_request_dto.dart';
import '../../../authorization/dto/authorization_response_dto.dart';
import '../../../authorization/model/authorization_request_model.dart';
import '../../../authorization/model/authorization_response_model.dart';

Future<AuthorizationResponseModel> authorizationService(
  Dio dio,
  AuthorizationRequestModel model,
) async {
  final requestDto = AuthorizationRequestDto.fromModel(model);

  final response = await dio.post(
    '$walletApiBaseUrl/authorization/authorization',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = AuthorizationResponseDto.fromJson(responseData);

  handleResponseCodes(responseDto.result);

  return responseDto.toModel();
}
