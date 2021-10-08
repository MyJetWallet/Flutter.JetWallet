import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/transfer_info/transfer_info_request_model.dart';
import '../../model/transfer_info/transfer_info_response_model.dart';
import '../transfer_service.dart';

Future<TransferInfoResponseModel> transferInfoService(
  Dio dio,
    TransferInfoRequestModel model,
) async {
  final logger = TransferService.logger;
  const message = 'transferInfoService';

  try {
    final response = await dio.post(
      '$walletApi/transfer/transfer-info',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return TransferInfoResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
