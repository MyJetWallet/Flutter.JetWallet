import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../operation_history/operation_history_service.dart';

Future<void> kycStartService(Dio dio) async {
  final logger = OperationHistoryService.logger;
  const message = 'kycStartService';

  try {
    await dio.get('$walletApi/kyc/verification/kyc_start');
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
