import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/execute_quote/execute_quote_request_model.dart';
import '../model/execute_quote/execute_quote_response_model.dart';
import '../model/get_quote/get_quote_request_model.dart';
import '../model/get_quote/get_quote_response_model.dart';
import 'services/execute_quote_service.dart';
import 'services/get_quote_service.dart';

class SwapService {
  SwapService(this.dio);

  final Dio dio;

  static final logger = Logger('SwapService');

  Future<ExecuteQuoteResponseModel> executeQuote(
    ExecuteQuoteRequestModel model,
    String localeName,
  ) {
    return executeQuoteService(dio, model, localeName);
  }

  Future<GetQuoteResponseModel> getQuote(
    GetQuoteRequestModel model,
    String localeName,
  ) {
    return getQuoteService(dio, model, localeName);
  }
}
