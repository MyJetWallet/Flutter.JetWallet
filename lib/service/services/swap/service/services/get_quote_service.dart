import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/get_quote/get_quote_request_model.dart';
import '../../model/get_quote/get_quote_response_model.dart';

Future<GetQuoteResponseModel> getQuoteService(
  Dio dio,
  GetQuoteRequestModel model,
) async {
  final response = await dio.post(
    '$walletApiBaseUrl/swap/get-quote',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final data = handleFullResponse<Map>(responseData);

  return GetQuoteResponseModel.fromJson(data);
}
