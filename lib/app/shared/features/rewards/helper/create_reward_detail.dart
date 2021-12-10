import 'package:flutter/material.dart';
import '../../../../../service/services/signal_r/model/campaign_response_model.dart';

import 'reward_description_item.dart';

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
