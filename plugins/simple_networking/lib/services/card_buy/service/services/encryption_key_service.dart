import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/encription_key/encryption_key_response_model.dart';
import '../card_buy_service.dart';

Future<EncryptionKeyCardResponseModel> encryptionKeyCardService(
  Dio dio,
  String localeName,
) async {
  final logger = CardBuyService.logger;
  const message = 'encryptionKeyService';

  try {
    final response = await dio.get(
      '$walletApi/trading/buy/get-encryption-key',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(
        responseData,
        localeName,
      );

      return EncryptionKeyCardResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
