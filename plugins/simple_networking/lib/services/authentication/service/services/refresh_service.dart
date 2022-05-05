import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
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
      '$authApi/trader/RefreshToken',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return AuthRefreshResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
