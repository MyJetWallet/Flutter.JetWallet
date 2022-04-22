import 'package:dio/dio.dart';

import '../../../../shared/logging/levels.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../wallet/service/wallet_service.dart';
import '../model/recurring_manage_request_model.dart';

Future<void> switchRecurringStatusService(
  Dio dio,
  RecurringManageRequestModel model,
) async {
  final logger = WalletService.logger;
  const message = 'switchRecurringStatusService';

  try {
    await dio.post(
      '$walletApi/trading/invest/switch',
      data: model,
    );

  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
