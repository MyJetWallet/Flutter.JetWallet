import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/providers/service_providers.dart';
import '../../../shared/features/rewards/model/campaign_response_model.dart';

final marketCampaignsSpod =
    StreamProvider.autoDispose<CampaignResponseModel>((ref) {
  ref.maintainState = true;

  final signalRService = ref.watch(signalRServicePod);

  return signalRService.marketCampaigns();
});
