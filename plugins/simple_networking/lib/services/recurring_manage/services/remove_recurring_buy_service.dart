import 'package:dio/dio.dart';

import '../../../shared/api_urls.dart';
import '../../../shared/constants.dart';
import '../../wallet/service/wallet_service.dart';
import '../model/recurring_delete_request_model.dart';

Future<void> removeRecurringBuyService(
  Dio dio,
  RecurringDeleteRequestModel model,
) async {
  final logger = WalletService.logger;
  const message = 'removeRecurringBuyService';

  try {
    await dio.delete(
      '$walletApi/trading/invest/delete',
      data: model,
    );
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
