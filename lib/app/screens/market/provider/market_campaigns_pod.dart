import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/campaign/model/campaign_model.dart';
import '../../../shared/features/rewards/notifier/campaign_notipod.dart';
import 'market_campaigns_spod.dart';

final marketCampaignsPod = Provider.autoDispose<List<CampaignModel>>((ref) {
  final campaigns = ref.watch(marketCampaignsSpod);
  final campaignNotifier = ref.read(campaignNotipod.notifier);

  final items = <CampaignModel>[];

  campaigns.whenData((value) {
    for (final marketCampaign in value.campaigns) {
      items.add(marketCampaign);
    }

    campaignNotifier.updateCampaigns(value.campaigns);
  });

  return items;
});
