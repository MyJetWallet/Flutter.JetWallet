import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/simplex_payment_request_model.dart';
import '../model/simplex_payment_response_model.dart';
import 'services/payment_service.dart';

class SimplexService {
  SimplexService(this.dio);

  final Dio dio;

  static final logger = Logger('SimplexService');

  Future<SimplexPaymentResponseModel> payment(
    SimplexPaymentRequestModel model,
    String localeName,
  ) {
    return paymentService(dio, model, localeName);
  }
}
