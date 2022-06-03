import 'package:dio/dio.dart';

import '../../../shared/api_urls.dart';
import '../../../shared/constants.dart';
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
