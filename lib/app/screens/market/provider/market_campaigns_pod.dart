import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/features/rewards/model/campaign_model.dart';
import 'market_campaigns_spod.dart';

final marketCampaignsPod = Provider.autoDispose<List<CampaignModel>>((ref) {
  final campaigns = ref.watch(marketCampaignsSpod);
  final items = <CampaignModel>[];

  campaigns.whenData((value) {
    for (final marketCampaign in value.campaigns) {
      items.add(marketCampaign);
    }
  });

  return items;
});
