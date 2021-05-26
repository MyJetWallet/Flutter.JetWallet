import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/execute_quote/execute_quote_request_model.dart';
import '../../model/execute_quote/execute_quote_response_model.dart';

Future<ExecuteQuoteResponseModel> executeQuoteService(
  Dio dio,
  ExecuteQuoteRequestModel model,
) async {
  final response = await dio.post(
    '$walletApiBaseUrl/swap/execute-quote',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final data = handleFullResponse<Map>(responseData);

  return ExecuteQuoteResponseModel.fromJson(data);
}
