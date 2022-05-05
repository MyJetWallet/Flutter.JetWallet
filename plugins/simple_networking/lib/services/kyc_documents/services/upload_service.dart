import 'package:dio/dio.dart';

import '../../../shared/api_urls.dart';
import '../../../shared/constants.dart';
import '../../../shared/helpers/handle_api_responses.dart';
import '../../operation_history/operation_history_service.dart';

Future<void> uploadService(
  Dio dio,
  FormData formData,
  int documentType,
) async {
  final logger = OperationHistoryService.logger;
  const message = 'uploadService';

  try {
    final response = await dio.post(
      '$walletApi/kyc/verification/kyc_documents/$documentType',
      data: formData,
    );

    try {
      final responseData = response.data as Map<String, dynamic>;
      handleResultResponse(responseData);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
