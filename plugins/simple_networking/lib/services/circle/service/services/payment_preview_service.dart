import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/payment_preview/payment_preview_request_model.dart';
import '../../model/payment_preview/payment_preview_response_model.dart';
import '../circle_service.dart';

Future<PaymentPreviewResponseModel> paymentPreviewService(
  Dio dio,
  PaymentPreviewRequestModel model,
  String localeName,
) async {
  final logger = CircleService.logger;
  const message = 'paymentPreviewService';

  try {
    final response = await dio.post(
      '$walletApi/circle/get-payment-preview',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return PaymentPreviewResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
