import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/tranfer_by_phone/transfer_by_phone_request_model.dart';
import '../../model/tranfer_by_phone/transfer_by_phone_response_model.dart';
import '../transfer_service.dart';

Future<TransferByPhoneResponseModel> transferByPhoneService(
  Dio dio,
  TransferByPhoneRequestModel model,
) async {
  final logger = TransferService.logger;
  const message = 'transferByPhoneService';

  try {
    final response = await dio.post(
      '$walletApi/transfer/by-phone',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return TransferByPhoneResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
