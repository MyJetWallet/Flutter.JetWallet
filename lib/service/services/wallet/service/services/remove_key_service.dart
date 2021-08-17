import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../wallet_service.dart';

Future<void> keyValueRemoveService(
  Dio dio,
  String key,
) async {
  final logger = WalletService.logger;
  const message = 'removeKeyService';

  try {
    await dio.post(
      '$walletApi/key-value/remove',
      data: key,
    );

  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
