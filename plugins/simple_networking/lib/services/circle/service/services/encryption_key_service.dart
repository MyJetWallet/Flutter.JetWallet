import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/encryption_key/encryption_key_response_model.dart';
import '../circle_service.dart';

Future<EncryptionKeyResponseModel> encryptionKeyService(
  Dio dio,
  String localeName,
) async {
  final logger = CircleService.logger;
  const message = 'encryptionKeyService';

  try {
    final response = await dio.get(
      '$walletApi/circle/get-encryption-key',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(
        responseData,
        localeName,
      );

      return EncryptionKeyResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
