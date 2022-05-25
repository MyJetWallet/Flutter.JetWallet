import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/session_info_response_model.dart';
import '../info_service.dart';

Future<SessionInfoResponseModel> sessionInfoService(
  Dio dio,
  String localeName,
) async {
  final logger = InfoService.logger;
  const message = 'sessionInfoService';

  try {
    final response = await dio.get(
      '$walletApi/info/session-info',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return SessionInfoResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message, e);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message, e);
    rethrow;
  }
}
