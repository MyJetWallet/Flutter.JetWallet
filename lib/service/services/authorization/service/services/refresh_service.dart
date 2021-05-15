import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_response_codes.dart';
import '../../../authorization/dto/refresh_request_dto.dart';
import '../../../authorization/model/authorization_refresh_request_model.dart';
import '../../dto/authorization_response_dto.dart';
import '../../model/authorization_response_model.dart';

Future<AuthorizationResponseModel> refreshService(
  Dio dio,
  AuthorizationRefreshRequestModel model,
) async {
  final requestDto = RefreshRequestDto.fromModel(model);

  final response = await dio.post(
    '$tradingAuthBaseUrl/authorization/refresh',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = AuthorizationResponseDto.fromJson(responseData);

  handleResponseCodes(responseDto.responseCodes);

  return responseDto.toModel();
}
