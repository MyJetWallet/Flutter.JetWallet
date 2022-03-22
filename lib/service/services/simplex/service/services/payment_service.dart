import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/simplex_payment_request_model.dart';
import '../../model/simplex_payment_response_model.dart';
import '../simplex_service.dart';

Future<SimplexPaymentResponseModel> paymentService(
  Dio dio,
  SimplexPaymentRequestModel model,
) async {
  final logger = SimplexService.logger;
  const message = 'paymentService';

  try {
    final response = await dio.post(
      '$walletApi/simplex/payment',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return SimplexPaymentResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
