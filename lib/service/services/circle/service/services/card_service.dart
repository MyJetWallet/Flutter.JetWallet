import 'package:dio/dio.dart';

import '../../model/card/card_request_model.dart';
import '../../model/card/card_response_model.dart';

Future<CardResponseModel> cardService(
  Dio dio,
  CardRequestModel model,
) async {
  final response = await dio.post(
    'url',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  return CardResponseModel.fromJson(responseData);
}
