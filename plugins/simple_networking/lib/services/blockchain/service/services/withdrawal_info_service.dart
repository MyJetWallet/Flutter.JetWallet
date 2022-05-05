import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/withdrawal_info/withdrawal_info_request_model.dart';
import '../../model/withdrawal_info/withdrawal_info_response_model.dart';
import '../blockchain_service.dart';

Future<WithdrawalInfoResponseModel> withdrawalInfoService(
  Dio dio,
  WithdrawalInfoRequestModel model,
) async {
  final logger = BlockchainService.logger;
  const message = 'withdrawInfoService';

  try {
    final response = await dio.post(
      '$walletApi/blockchain/withdrawal-info',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return WithdrawalInfoResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
