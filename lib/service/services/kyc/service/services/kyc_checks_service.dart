import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../../operation_history/operation_history_service.dart';
import '../../model/kyc_checks_response_model.dart';

Future<KycChecksResponseModel> kycChecksService(Dio dio) async {
  final logger = OperationHistoryService.logger;
  const message = 'operationHistoryService';

  try {
    final response = await dio.get('$walletApi/kyc/verification/kyc_checks');

    try {
      final responseData = response.data as Map<String, dynamic>;
      final data = handleFullResponse<Map>(responseData);
      return KycChecksResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
