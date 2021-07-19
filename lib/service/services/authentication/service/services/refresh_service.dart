import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../model/refresh/auth_refresh_request_model.dart';
import '../../model/refresh/auth_refresh_response_model.dart';
import '../authentication_service.dart';

Future<AuthRefreshResponseModel> refreshService(
  Dio dio,
  AuthRefreshRequestModel model,
) async {
  final logger = AuthenticationService.logger;
  const message = 'refreshService';

  try {
    final response = await dio.post(
      '$tradingAuthApi/Trader/RefreshToken',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      return AuthRefreshResponseModel.fromJson(responseData);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
