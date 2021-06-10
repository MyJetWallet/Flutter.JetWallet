import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/register_token_request_model.dart';

Future<void> registerTokenService(
  Dio dio,
  RegisterTokenRequestModel model,
) async {
  final response = await dio.post(
    '$walletApiBaseUrl/push/token',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  handleResultResponse(responseData);
}
