import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../model/refresh/auth_refresh_request_model.dart';
import '../../model/refresh/auth_refresh_response_model.dart';

Future<AuthRefreshResponseModel> refreshService(
  Dio dio,
  AuthRefreshRequestModel model,
) async {
  final response = await dio.post(
    '$tradingAuthBaseUrl/Trader/RefreshToken',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  return AuthRefreshResponseModel.fromJson(responseData);
}
