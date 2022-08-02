import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../wallet/service/wallet_service.dart';
import '../../models/remote_config_model.dart';

Future<RemoteConfigModel> getRemoteConfigService(
  String url,
  Dio dio,
  String localeName,
) async {
  final logger = WalletService.logger;
  const message = 'newsService';

  try {
    final response = await dio.get(
      '$url/remote-config/config',
    );

    try {
      Map<String, dynamic> responseData;

      if (response.data is String) {
        responseData =
            jsonDecode(response.data as String) as Map<String, dynamic>;
      } else {
        responseData = response.data as Map<String, dynamic>;
      }

      return RemoteConfigModel.fromJson(responseData);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
