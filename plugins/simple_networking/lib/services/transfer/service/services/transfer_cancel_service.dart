import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/transfer_cancel/transfer_cancel_request_model.dart';
import '../../model/transfer_cancel/transfer_cancel_response_model.dart';
import '../transfer_service.dart';

Future<TransferCancelResponseModel> transferCancelService(
  Dio dio,
    TransferCancelRequestModel model,
  String localeName,
) async {
  final logger = TransferService.logger;
  const message = 'transferCancelService';

  try {
    final response = await dio.post(
      '$walletApi/transfer/transfer-cancel',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;
      final data = handleFullResponse<Map>(responseData, localeName,);

      return TransferCancelResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
