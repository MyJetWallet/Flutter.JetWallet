import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../model/condition_type.dart';
import 'set_reward_description_style.dart';

Widget setRewardDescriptionItem(
  CampaignConditionModel condition,
  List<CampaignConditionModel> conditions,
  SimpleColors colors,
) {
  return Row(
    children: [
      if (condition.type == conditionTypeSwitch(ConditionType.kYCCondition) ||
          condition.type == conditionTypeSwitch(ConditionType.depositCondition))
        Text(
          'Get',
          style: setRewardDescriptionStyle(
            condition,
            conditions,
            colors,
          ),
        ),
      if (condition.parameters != null && condition.parameters!.asset == null)
        Text(
          ' \$',
          style: setRewardDescriptionStyle(
            condition,
            conditions,
            colors,
          ),
        ),
      if (condition.type == conditionTypeSwitch(ConditionType.tradeCondition))
        Text(
          '\$${condition.reward!.amount.toStringAsFixed(0)}',
          style: setRewardDescriptionStyle(
            condition,
            conditions,
            colors,
          ),
        ),
      if (condition.type == conditionTypeSwitch(ConditionType.kYCCondition))
        Text(
          '${condition.reward!.amount.toStringAsFixed(0)}'
              ' for account verification',
          style: setRewardDescriptionStyle(
            condition,
            conditions,
            colors,
          ),
        ),
      if (condition.type == conditionTypeSwitch(ConditionType.depositCondition))
        Text(
          '${condition.reward!.amount.toStringAsFixed(0)}'
              ' after making first deposit',
          style: setRewardDescriptionStyle(
            condition,
            conditions,
            colors,
          ),
        ),
      if (condition.type == conditionTypeSwitch(ConditionType.tradeCondition))
        Text(
          ' after trading \$100 (44/${condition.parameters!.requiredAmount})',
          style: setRewardDescriptionStyle(
            condition,
            conditions,
            colors,
          ),
        ),
    ],
  );
}
