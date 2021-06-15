import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/withdrawal/withdrawal_request_model.dart';
import '../../model/withdrawal/withdrawal_response_model.dart';
import '../blockchain_service.dart';

Future<WithdrawalResponseModel> withdrawalService(
  Dio dio,
  WithdrawalRequestModel model,
) async {
  final logger = BlockchainService.logger;
  const message = 'withdrawalService';

  try {
    final response = await dio.post(
      '$walletApiBaseUrl/blockchain/withdrawal',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return WithdrawalResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
