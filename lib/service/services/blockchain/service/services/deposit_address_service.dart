import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../shared/api_urls.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/deposit_address/deposit_address_request_model.dart';
import '../../model/deposit_address/deposit_address_response_model.dart';
import '../blockchain_service.dart';

Future<DepositAddressResponseModel> depositAddressService(
  Dio dio,
  DepositAddressRequestModel model,
) async {
  final logger = BlockchainService.logger;
  const message = 'depositAddressService';

  try {
    final response = await dio.post(
      '$walletApi/blockchain/generate-deposit-address',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return DepositAddressResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
