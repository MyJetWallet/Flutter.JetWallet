import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../../authorization/model/authorization_refresh_request_model.dart';
import '../../dto/authorization_refresh_request_dto.dart';
import '../../dto/authorization_response_dto.dart';
import '../../model/authorization_response_model.dart';

Future<AuthorizationResponseModel> refreshService(
  Dio dio,
  AuthorizationRefreshRequestModel model,
) async {
  final requestDto = AuthorizationRefreshRequestDto.fromModel(model);

  final response = await dio.post(
    '$walletApiBaseUrl/authorization/refresh',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final data = handleFullResponse<String>(responseData);

  final responseDto = AuthorizationResponseDto.fromJson(data);

  return responseDto.toModel();
}
