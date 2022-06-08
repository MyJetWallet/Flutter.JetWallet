import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/payment_info/payment_info_request_model.dart';
import '../../model/payment_info/payment_info_response_model.dart';
import '../circle_service.dart';

Future<PaymentInfoResponseModel> paymentInfoService(
  Dio dio,
  PaymentInfoRequestModel model,
  String localeName,
) async {
  final logger = CircleService.logger;
  const message = 'paymentInfoService';

  try {
    final response = await dio.get(
      '$walletApi/circle/get-payment-info/${model.depositId}',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return PaymentInfoResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
