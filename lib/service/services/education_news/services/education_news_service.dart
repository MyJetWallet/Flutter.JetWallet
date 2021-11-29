import 'package:dio/dio.dart';

import '../../../../shared/logging/levels.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../shared/helpers/handle_api_responses.dart';
import '../../wallet/service/wallet_service.dart';
import '../model/education_news_request_model.dart';
import '../model/education_news_response_model.dart';

Future<EducationNewsResponseModel> educationNewsService(
    Dio dio,
    EducationNewsRequestModel model,
    ) async {
  final logger = WalletService.logger;
  const message = 'educationNewsService';

  try {
    final response = await dio.post(
      '$walletApi/market/news',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);
      return EducationNewsResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
