import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../dto/authentication_refresh_request_dto.dart';
import '../../dto/authentication_refresh_response_dto.dart';
import '../../model/authentication_refresh_request_model.dart';
import '../../model/authentication_refresh_response_model.dart';

Future<AuthenticationRefreshResponseModel> refreshService(
  Dio dio,
  AuthenticationRefreshRequestModel model,
) async {
  final requestDto = AuthenticationRefreshRequestDto.fromModel(model);

  final response = await dio.post(
    '$tradingAuthBaseUrl/Trader/RefreshToken',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = AuthenticationRefreshResponseDto.fromJson(responseData);

  return responseDto.toModel();
}
