import 'package:dio/dio.dart';

import '../../model/all_cards/all_cards_response_model.dart';

Future<AllCardsResponseModel> allCardsService(Dio dio) async {
  final response = await dio.get(
    'url',
  );

  final responseData = response.data as Map<String, dynamic>;

  return AllCardsResponseModel.fromJson(responseData);
}
