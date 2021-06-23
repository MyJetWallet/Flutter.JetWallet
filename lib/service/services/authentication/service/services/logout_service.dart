import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../shared/api_urls.dart';
import '../../model/logout/logout_request_model.dart';
import '../authentication_service.dart';

Future<void> logoutService(
  Dio dio,
  LogoutRequestModel model,
) async {
  try {
    await dio.post(
      '$tradingAuthBaseUrl/Trader/Logout',
      data: model.toJson(),
    );
  } catch (e) {
    AuthenticationService.logger.log(transport, 'logoutService', e);
    rethrow;
  }
}
