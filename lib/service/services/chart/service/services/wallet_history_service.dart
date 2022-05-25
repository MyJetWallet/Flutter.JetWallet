import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/wallet_history_request_model.dart';
import '../../model/wallet_history_response_model.dart';
import '../chart_service.dart';

Future<WalletHistoryResponseModel> walletHistoryService(
  Dio dio,
  WalletHistoryRequestModel model,
  String localeName,
) async {
  final logger = ChartService.logger;
  const message = 'walletHistoryService';

  try {
    final response = await dio.get(
      '$walletApi/portfolio/history-graph',
      queryParameters: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName,);

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
