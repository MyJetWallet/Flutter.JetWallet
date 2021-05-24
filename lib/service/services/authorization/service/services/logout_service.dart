import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';

Future<void> logoutService(Dio dio) async {
  final response = await dio.post(
    '$walletApiBaseUrl/authorization/logout',
  );

  final responseData = response.data as Map<String, dynamic>;

  handleResultResponse(responseData);
}
