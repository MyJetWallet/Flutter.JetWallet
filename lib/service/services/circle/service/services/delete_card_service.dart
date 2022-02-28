import 'package:dio/dio.dart';

import '../../model/delete_card/delete_card_request_model.dart';
import '../../model/delete_card/delete_card_response_model.dart';

Future<DeleteCardResponseModel> deleteCardService(
  Dio dio,
  DeleteCardRequestModel model,
) async {
  final response = await dio.post(
    'url',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  return DeleteCardResponseModel.fromJson(responseData);
}
