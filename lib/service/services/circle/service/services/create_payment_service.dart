import 'package:dio/dio.dart';

import '../../model/create_payment/create_payment_request_model.dart';
import '../../model/create_payment/create_payment_response_model.dart';

Future<CreatePaymentResponseModel> createPaymentService(
  Dio dio,
  CreatePaymentRequestModel model,
) async {
  final response = await dio.post(
    'url',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  return CreatePaymentResponseModel.fromJson(responseData);
}
