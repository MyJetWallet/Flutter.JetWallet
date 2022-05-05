import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/candles_request_model.dart';
import '../model/candles_response_model.dart';
import '../model/wallet_history_request_model.dart';
import '../model/wallet_history_response_model.dart';
import 'services/candles_service.dart';
import 'services/wallet_history_service.dart';

class ChartService {
  ChartService(this.dio);

  final Dio dio;

  static final logger = Logger('ChartService');

  Future<CandlesResponseModel> candles(CandlesRequestModel model) {
    return candlesService(dio, model);
  }

  Future<WalletHistoryResponseModel> walletHistory(
    WalletHistoryRequestModel model,
  ) {
    return walletHistoryService(dio, model);
  }
}
