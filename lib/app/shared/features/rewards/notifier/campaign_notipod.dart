import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'campaign_notifier.dart';
import 'campaign_state.dart';

final campaignNotipod =
StateNotifierProvider<CampaignNotifier, CampaignState>(
      (ref) {
    return CampaignNotifier(
      read: ref.read,
    );
  },
);
