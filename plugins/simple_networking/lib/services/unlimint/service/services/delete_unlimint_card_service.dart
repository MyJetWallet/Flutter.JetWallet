import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/delete_unlimint_card_request_model.dart';
import '../../model/delete_unlimint_card_response_model.dart';
import '../unlimint_service.dart';

Future<DeleteUnlimintCardResponseModel> deleteUnlimintCardService(
  Dio dio,
  DeleteUnlimintCardRequestModel model,
  String localeName,
) async {
  final logger = UnlimintService.logger;
  const message = 'deleteCardService';

  try {
    final response = await dio.post(
      '$walletApi/unlimint-card/remove',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;
      final data = handleFullResponse<Map>(
        responseData,
        localeName,
      );

      return DeleteUnlimintCardResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
