import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/withdrawal_resend/withdrawal_resend_request.dart';
import '../blockchain_service.dart';

Future<void> withdrawalResendService(
  Dio dio,
  WithdrawalResendRequestModel model,
  String localeName,
) async {
  final logger = BlockchainService.logger;
  const message = 'withdrawalResendService';

  try {
    final response = await dio.post(
      '$walletApi/blockchain/withdrawal-resend',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData, localeName);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
