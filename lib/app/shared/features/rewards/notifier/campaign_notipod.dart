import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../screens/market/provider/market_campaigns_pod.dart';

import 'campaign_notifier.dart';
import 'campaign_state.dart';

final campaignNotipod = StateNotifierProvider.autoDispose
    .family<CampaignNotifier, CampaignState, bool>(
  (ref, isFilterEnabled) {
    final campaigns = ref.watch(marketCampaignsPod);

    return CampaignNotifier(
      read: ref.read,
      campaigns: campaigns,
      isFilterEnabled: isFilterEnabled,
    );
  },
);
