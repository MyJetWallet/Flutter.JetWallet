import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/delete_card/delete_card_request_model.dart';
import '../../model/delete_card/delete_card_response_model.dart';
import '../circle_service.dart';

Future<DeleteCardResponseModel> deleteCardService(
  Dio dio,
  DeleteCardRequestModel model,
) async {
  final logger = CircleService.logger;
  const message = 'deleteCardService';

  try {
    final response = await dio.post(
      '$walletApi/circle/delete-card',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      return DeleteCardResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
