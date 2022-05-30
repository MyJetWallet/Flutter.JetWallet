import 'package:dio/dio.dart';

import '../../../shared/api_urls.dart';
import '../../../shared/constants.dart';
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
