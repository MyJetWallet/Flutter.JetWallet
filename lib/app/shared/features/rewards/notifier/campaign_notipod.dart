import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../../screens/market/provider/market_campaigns_pod.dart';
import 'campaign_notifier.dart';

final campaignNotipod = StateNotifierProvider.autoDispose
    .family<CampaignNotifier, List<CampaignModel>, bool>(
  (ref, isFilterEnabled) {
    final campaigns = ref.watch(marketCampaignsPod);

    return CampaignNotifier(
      read: ref.read,
      campaigns: campaigns,
      isFilterEnabled: isFilterEnabled,
    );
  },
);
