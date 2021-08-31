import 'package:dio/dio.dart';

import '../../../../shared/logging/levels.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../wallet/service/wallet_service.dart';

Future<void> removeKeyValueService(
  Dio dio,
  List<String> keys,
) async {
  final logger = WalletService.logger;
  const message = 'removeKeyValueService';

  try {
    await dio.post(
      '$walletApi/key-value/remove',
      data: keys,
    );

  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
