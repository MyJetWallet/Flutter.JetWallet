import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/rewards/model/campaign_or_referral_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'reward_store.g.dart';

class RewardStore extends _RewardStoreBase with _$RewardStore {
  RewardStore() : super();

  static _RewardStoreBase of(BuildContext context) => Provider.of<RewardStore>(context, listen: false);
}

abstract class _RewardStoreBase with Store {
  _RewardStoreBase() {
    final campaigns = sSignalRModules.marketCampaigns.map(
      (e) {
        return CampaignModel(
          conditions: e.conditions?.map((e) {
            return e.parameters != null && e.reward != null
                ? CampaignConditionModel(
                    parameters: CampaignConditionParametersModel(
                      passed: e.parameters?.passed ?? '',
                      asset: e.parameters?.asset ?? '',
                      requiredAmount: e.parameters?.requiredAmount ?? '',
                      tradedAmount: e.parameters?.tradedAmount ?? '',
                    ),
                    reward: RewardModel(
                      amount: e.reward?.amount ?? Decimal.zero,
                      asset: e.reward?.asset ?? '',
                    ),
                    deepLink: e.deepLink,
                    type: e.type,
                    description: e.description,
                  )
                : CampaignConditionModel(
                    deepLink: e.deepLink,
                    type: e.type,
                    description: e.description,
                  );
          }).toList(),
          imageUrl: e.imageUrl,
          showReferrerStats: e.showReferrerStats,
          timeToComplete: e.timeToComplete,
          weight: e.weight,
          title: e.title,
          description: e.description,
          campaignId: e.campaignId,
          deepLink: e.deepLink,
        );
      },
    ).toList();

    final referralStats = sSignalRModules.referralStats
        .map(
          (e) => ReferralStatsModel(
            weight: e.weight,
            referralInvited: e.referralInvited,
            referralActivated: e.referralActivated,
            descriptionLink: e.descriptionLink,
            bonusEarned: e.bonusEarned,
            commissionEarned: e.commissionEarned,
            total: e.total,
          ),
        )
        .toList();

    sortedCampaigns = ObservableList.of(_sort(campaigns, referralStats));
  }

  @observable
  ObservableList<CampaignOrReferralModel> sortedCampaigns = ObservableList.of([]);

  List<CampaignOrReferralModel> _sort(
    List<CampaignModel> campaigns,
    List<ReferralStatsModel> referralStats,
  ) {
    final combinedArray = <CampaignOrReferralModel>[];
    final campaignsArray = List<CampaignModel>.from(campaigns);
    final referralStatsArray = List<ReferralStatsModel>.from(referralStats);

    for (final campaign in campaignsArray) {
      if (campaign.conditions == null || (campaign.conditions != null && campaign.conditions!.isEmpty)) {
        combinedArray.add(CampaignOrReferralModel(campaign: campaign));
      }
    }

    for (final campaign in campaignsArray) {
      if (campaign.conditions != null && (campaign.conditions != null && campaign.conditions!.isNotEmpty)) {
        combinedArray.add(CampaignOrReferralModel(campaign: campaign));
      }
    }

    for (final referralStat in referralStatsArray) {
      combinedArray.add(CampaignOrReferralModel(referralState: referralStat));
    }

    return combinedArray.toSet().toList();
  }
}
