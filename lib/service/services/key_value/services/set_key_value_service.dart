import 'package:dio/dio.dart';

import '../../../../shared/logging/levels.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../wallet/service/wallet_service.dart';
import '../model/key_value_request_model.dart';

Future<void> setKeyValueService(
  Dio dio,
  KeyValueRequestModel model,
) async {
  final logger = WalletService.logger;
  const message = 'setKeyValueService';

  try {
    await dio.post(
      '$walletApi/key-value/set',
      data: model,
    );

  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
