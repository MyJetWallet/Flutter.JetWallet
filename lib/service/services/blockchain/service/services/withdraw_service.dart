import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/withdraw/withdraw_request_model.dart';
import '../../model/withdraw/withdraw_response_model.dart';
import '../blockchain_service.dart';

Future<WithdrawResponseModel> withdrawService(
  Dio dio,
  WithdrawRequestModel model,
  String localeName,
) async {
  final logger = BlockchainService.logger;
  const message = 'withdrawService';

  try {
    final response = await dio.post(
      '$walletApi/blockchain/withdrawal',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return WithdrawResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
