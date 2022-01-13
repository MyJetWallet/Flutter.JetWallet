import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../../operation_history/operation_history_service.dart';

Future<void> uploadDocumentsService(Dio dio, int documentType) async {
  final logger = OperationHistoryService.logger;
  const message = 'uploadDocumentsService';

  try {
    final response = await dio.post(
      '$walletApi/kyc/verification/kyc_documents/$documentType',

    );

    try {
      final responseData = response.data as Map<String, dynamic>;
      final data = handleFullResponse<Map>(responseData);
      // return KycChecksResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
