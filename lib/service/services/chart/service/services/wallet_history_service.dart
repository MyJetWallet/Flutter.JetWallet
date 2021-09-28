import 'package:dio/dio.dart';
import 'package:jetwallet/service/services/chart/model/wallet_history_request_model.dart';
import 'package:jetwallet/service/services/chart/model/wallet_history_response_model.dart';
import 'package:jetwallet/service/shared/helpers/handle_api_responses.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../chart_service.dart';

Future<WalletHistoryResponseModel> walletHistoryService(
  Dio dio,
  WalletHistoryRequestModel model,
) async {
  final logger = ChartService.logger;
  const message = 'walletHistoryService';

  try {
    final response = await dio.get(
      '$walletApi/history/wallet-history/history-graph',
      queryParameters: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;
      final data = handleFullResponse<Map>(responseData);

      return WalletHistoryResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
