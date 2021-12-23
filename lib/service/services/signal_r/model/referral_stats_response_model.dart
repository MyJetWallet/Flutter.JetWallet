import 'package:freezed_annotation/freezed_annotation.dart';
import 'campaign_response_model.dart';

part 'referral_stats_response_model.freezed.dart';
part 'referral_stats_response_model.g.dart';

@freezed
class ReferralStatsResponseModel with _$ReferralStatsResponseModel {
  const factory ReferralStatsResponseModel({
    required List<ReferralStatsModel> referralStats,
  }) = _ReferralStatsResponseModel;

  factory ReferralStatsResponseModel.fromList(List<dynamic> list) {
    return ReferralStatsResponseModel(
      referralStats: list
          .map((e) => ReferralStatsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

@freezed
class ReferralStatsModel with _$ReferralStatsModel {
  const factory ReferralStatsModel({
    required int weight,
    required int referralInvited,
    required int referralActivated,
    required double bonusEarned,
    required double commissionEarned,
    required double total,
  }) = _ReferralStatsModel;

  factory ReferralStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ReferralStatsModelFromJson(json);
}

@freezed
class CampaignAndReferralStatsModel with _$CampaignAndReferralStatsModel {
  const factory CampaignAndReferralStatsModel({
    @Default(<ReferralStatsModel>[]) List<ReferralStatsModel> referralStats,
    @Default(<CampaignModel>[]) List<CampaignModel> campaigns,
  }) = _CampaignAndReferralStatsModel;
}
