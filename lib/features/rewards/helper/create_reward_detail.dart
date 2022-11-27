import 'package:flutter/material.dart';
import 'package:jetwallet/features/rewards/helper/reward_description_item.dart';
import 'package:jetwallet/features/rewards/model/campaign_or_referral_model.dart';

List<Widget> createRewardDetail(
  List<CampaignConditionModel> conditions,
) {
  final rewardDetails = <Widget>[];
  for (final condition in conditions) {
    rewardDetails.add(
      RewardsDescriptionItem(
        condition: condition,
        conditions: conditions,
      ),
    );
  }

  return rewardDetails;
}
