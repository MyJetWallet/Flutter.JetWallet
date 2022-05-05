import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/create_payment/create_payment_request_model.dart';
import '../../model/create_payment/create_payment_response_model.dart';
import '../circle_service.dart';

Future<CreatePaymentResponseModel> createPaymentService(
  Dio dio,
  CreatePaymentRequestModel model,
) async {
  final logger = CircleService.logger;
  const message = 'createPaymentService';

  try {
    final response = await dio.post(
      '$walletApi/circle/create-payment',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return CreatePaymentResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
