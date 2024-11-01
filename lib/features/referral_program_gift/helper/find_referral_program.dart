import 'package:simple_networking/modules/signal_r/models/campaign_response_model.dart';

List<CampaignModel> findReferralProgram(List<CampaignModel> campaigns) {
  for (final campaign in campaigns) {
    if (campaign.conditions != null && campaign.conditions!.isNotEmpty) {
      for (final condition in campaign.conditions!) {
        if (condition.reward != null) {
          return [campaign];
        }
      }
    }
  }

  return [];
}
