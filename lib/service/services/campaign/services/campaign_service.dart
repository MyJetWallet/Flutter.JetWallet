import 'package:dio/dio.dart';

import '../../../../shared/logging/levels.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../shared/helpers/handle_api_responses.dart';
import '../../wallet/service/wallet_service.dart';
import '../model/campaign_request_model.dart';
import '../model/campaign_response_model.dart';

Future<CampaignResponseModel> campaignService(
  Dio dio,
  CampaignRequestModel model,
) async {
  final logger = WalletService.logger;
  const message = 'campaignService';

  try {
    final response = await dio.get(
      '$walletApi/campaign/campaigns/${model.lang}',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;
      final data = handleFullResponse<Map>(responseData);

      return CampaignResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
