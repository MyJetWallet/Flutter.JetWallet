import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
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

      final data = handleFullResponse<Map>(responseData);

      return AllCardsResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
