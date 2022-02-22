import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../model/condition_type.dart';
import 'set_reward_description_style.dart';

Widget createRewardDescriptionItem(
  CampaignConditionModel condition,
  List<CampaignConditionModel> conditions,
  SimpleColors colors,
  Function(String) onTap,
) {
  return GestureDetector(
    onTap: () => onTap(condition.deepLink),
    child: Row(
      children: [
        if (condition.type == conditionTypeSwitch(ConditionType.kYCCondition) ||
            condition.type ==
                conditionTypeSwitch(ConditionType.depositCondition))
          Text(
            'Get',
            style: sBodyText1Style.copyWith(
              color: setRewardDescriptionStyle(
                condition,
                conditions,
                colors,
              ),
            ),
          ),
        if (condition.parameters != null && condition.parameters!.asset == null)
          Text(
            ' \$',
            style: sBodyText1Style.copyWith(
              color: setRewardDescriptionStyle(
                condition,
                conditions,
                colors,
              ),
            ),
          ),
        if (condition.type ==
                conditionTypeSwitch(ConditionType.tradeCondition) &&
            condition.reward != null)
          Text(
            '\$${condition.reward!.amount.toStringAsFixed(0)} ',
            style: sBodyText1Style.copyWith(
              color: setRewardDescriptionStyle(
                condition,
                conditions,
                colors,
              ),
            ),
          ),
        if (condition.type == conditionTypeSwitch(ConditionType.kYCCondition) &&
            condition.reward != null)
          Text(
            '${condition.reward!.amount.toStringAsFixed(0)}'
            ' for account verification',
            style: sBodyText1Style.copyWith(
              color: setRewardDescriptionStyle(
                condition,
                conditions,
                colors,
              ),
            ),
          ),
        if (condition.type ==
                conditionTypeSwitch(ConditionType.depositCondition) &&
            condition.reward != null)
          Text(
            '${condition.reward!.amount.toStringAsFixed(0)}'
            ' after making first deposit',
            style: sBodyText1Style.copyWith(
              color: setRewardDescriptionStyle(
                condition,
                conditions,
                colors,
              ),
            ),
          ),
        if (condition.type == conditionTypeSwitch(ConditionType.tradeCondition))
          Text(
            'after trading \$100 (${condition.parameters!.tradedAmount!.split('.')[0]}/${condition.parameters!.requiredAmount})',
            style: sBodyText1Style.copyWith(
              color: setRewardDescriptionStyle(
                condition,
                conditions,
                colors,
              ),
            ),
          ),
      ],
    ),
  );
}
