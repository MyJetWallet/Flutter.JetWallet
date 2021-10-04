import 'package:dio/dio.dart';

import '../../../../shared/logging/levels.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../shared/helpers/handle_api_responses.dart';
import '../model/operation_history_request_model.dart';
import '../model/operation_history_response_model.dart';
import '../operation_history_service.dart';

Future<OperationHistoryResponseModel> operationHistoryService(
  Dio dio,
  OperationHistoryRequestModel model,
) async {
  final logger = OperationHistoryService.logger;
  const message = 'operationHistoryService';

  try {
    final response = await dio.get(
      '$walletApi/history/wallet-history/operation-history',
      queryParameters: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<List>(responseData);

      return OperationHistoryResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
