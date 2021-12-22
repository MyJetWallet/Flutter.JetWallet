import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../../../service/services/signal_r/model/referral_stats_response_model.dart';

/// Can be only one type, not two at the same time
class CampaignOrReferralModel {
  CampaignOrReferralModel({
    this.campaign,
    this.referralStat,
  });

  final CampaignModel? campaign;
  final ReferralStatsModel? referralStat;
}
