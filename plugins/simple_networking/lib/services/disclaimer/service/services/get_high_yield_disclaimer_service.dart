import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/disclaimers_response_model.dart';
import '../disclaimers_service.dart';

Future<DisclaimersResponseModel> getHighYieldDisclaimersService(
  Dio dio,
  String localeName,
) async {
  final logger = DisclaimersService.logger;
  const message = 'getHighYieldDisclaimersService';

  try {
    final response = await dio.get(
      '$walletApi/profile/highyield-disclaimers',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(
        responseData,
        localeName,
      );

      return DisclaimersResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
