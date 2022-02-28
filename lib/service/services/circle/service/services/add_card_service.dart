import 'package:dio/dio.dart';

import '../../model/add_card/add_card_request_model.dart';
import '../../model/add_card/add_card_response_model.dart';

Future<AddCardResponseModel> addCardService(
  Dio dio,
  AddCardRequestModel model,
) async {
  final response = await dio.post(
    'url',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  return AddCardResponseModel.fromJson(responseData);
}
