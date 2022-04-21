import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../../screens/market/provider/market_campaigns_spod.dart';

final rewardsPod = Provider.autoDispose<List<CampaignModel>>((ref) {
  final campaigns = ref.watch(marketCampaignsSpod);
  final items = <CampaignModel>[];

  campaigns.whenData((value) {
    for (final marketCampaign in value.campaigns) {
      items.add(marketCampaign);
    }
  });

  return items;
});
