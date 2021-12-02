import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/campaign/model/campaign_request_model.dart';
import '../../../../../service/services/campaign/model/campaign_response_model.dart';
import '../../../../../shared/providers/service_providers.dart';

final campaignsInitFpod =
FutureProvider.autoDispose<CampaignResponseModel>((ref) async {
  final campaignService = ref.read(campaignServicePod);
  final intl = ref.watch(intlPod);

  final campaignResult = await campaignService.campaigns(
    CampaignRequestModel(
      lang: intl.localeName,
    ),
  );

  return campaignResult;
});
