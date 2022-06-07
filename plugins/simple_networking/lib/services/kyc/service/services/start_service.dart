import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../operation_history/operation_history_service.dart';

Future<void> startService(Dio dio) async {
  final logger = OperationHistoryService.logger;
  const message = 'startService';

  try {
    await dio.get('$walletApi/kyc/verification/kyc_start');
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
