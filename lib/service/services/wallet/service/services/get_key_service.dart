import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../wallet_service.dart';

// TODO(Vova): extrace to separate service, add serialization, rename file
Future<List<dynamic>> keyValueService(
  Dio dio,
) async {
  final logger = WalletService.logger;
  const message = 'getKeyService';

  try {
    final response = await dio.get(
      '$walletApi/key-value/debug/get',
    );

    try {
      final responseData = response.data as List<dynamic>;

      return responseData;
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
