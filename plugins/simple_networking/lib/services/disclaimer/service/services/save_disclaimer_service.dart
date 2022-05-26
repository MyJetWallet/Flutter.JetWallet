import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/disclaimers_request_model.dart';
import '../disclaimers_service.dart';

Future<void> saveDisclaimerService(
  Dio dio,
  DisclaimersRequestModel model,
  String localeName,
) async {
  final logger = DisclaimersService.logger;
  const message = 'postDisclaimersService';

  try {
    final response = await dio.post(
      '$walletApi/profile/disclaimers',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      handleResultResponse(responseData, localeName);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
