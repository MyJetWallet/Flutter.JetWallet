import '../../../../../service/services/signal_r/model/campaign_response_model.dart';

class CombinedRewardModel {
  CombinedRewardModel({
    this.weight,
    this.referralInvited,
    this.referralActivated,
    this.bonusEarned,
    this.commissionEarned,
    this.total,
    this.conditions,
    this.imageUrl,
    this.timeToComplete,
    this.showReferrerStats,
    this.title,
    this.description,
    this.campaignId,
    this.deepLink,
  });

  final int? weight;
  final int? referralInvited;
  final int? referralActivated;
  final double? bonusEarned;
  final double? commissionEarned;
  final double? total;

  final List<CampaignConditionModel>? conditions;
  final String? imageUrl;
  final String? timeToComplete;
  final bool? showReferrerStats;
  final String? title;
  final String? description;
  final String? campaignId;
  final String? deepLink;
}