import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/campaign/model/campaign_response_model.dart';
import '../../../../shared/providers/service_providers.dart';

final marketCampaignsSpod =
    StreamProvider.autoDispose<CampaignResponseModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.marketCampaigns();
});
