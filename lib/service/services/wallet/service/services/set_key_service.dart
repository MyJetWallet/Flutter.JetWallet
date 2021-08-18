import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../model/key_value/key_value_request_model.dart';
import '../wallet_service.dart';

// TODO(Vova): rename file
Future<void> keyValueSetService(
  Dio dio,
  KeyValueRequestModel model,
) async {
  final logger = WalletService.logger;
  const message = 'setKeyService';

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
