import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../model/logout/logout_request_model.dart';

Future<void> logoutService(
  Dio dio,
  LogoutRequestModel model,
) async {
  await dio.post(
    '$tradingAuthBaseUrl/Trader/Logout',
    data: model.toJson(),
  );
}
