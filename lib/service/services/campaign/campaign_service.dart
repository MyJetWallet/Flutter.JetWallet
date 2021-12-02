import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/campaign_request_model.dart';
import 'model/campaign_response_model.dart';
import 'services/campaign_service.dart';

class CampaignService {
  CampaignService(this.dio);

  final Dio dio;

  static final logger = Logger('CampaignService');

  Future<CampaignResponseModel> campaigns(
      CampaignRequestModel model,
      ) {
    return campaignService(dio, model);
  }
}
