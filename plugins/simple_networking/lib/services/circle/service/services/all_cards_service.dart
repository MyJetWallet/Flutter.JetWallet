import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../model/all_cards/all_cards_response_model.dart';
import '../circle_service.dart';

Future<AllCardsResponseModel> allCardsService(Dio dio) async {
  final logger = CircleService.logger;
  const message = 'allCardsService';

  try {
    final response = await dio.get(
      '$walletApi/circle/get-cards-all',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = responseData['data'] as List;

      return AllCardsResponseModel.fromList(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
