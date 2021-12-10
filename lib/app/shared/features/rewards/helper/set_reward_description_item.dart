import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../helpers/icon_url_from.dart';
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
          '\$${condition.reward!.amount}',
          style: setRewardDescriptionStyle(
            condition,
            conditions,
            colors,
          ),
        ),
      if (condition.type == conditionTypeSwitch(ConditionType.kYCCondition))
        Text(
          '${condition.reward!.amount} for account verification',
          style: setRewardDescriptionStyle(
            condition,
            conditions,
            colors,
          ),
        ),
      if (condition.type == conditionTypeSwitch(ConditionType.depositCondition))
        Text(
          '${condition.reward!.amount} after making first deposit',
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

Color _setStyle(
  CampaignConditionModel condition,
  List<CampaignConditionModel> conditions,
  SimpleColors colors,
) {
  if (conditions.length > 1) {
    if (condition.type == conditionTypeSwitch(ConditionType.kYCCondition)) {
      return (condition.parameters!.passed == 'false')
          ? colors.blue
          : colors.black;
    } else {
      final currentIndexCondition = conditions.indexOf(condition);
      final prevCondition = conditions[currentIndexCondition - 1];

      if (prevCondition.parameters!.passed == 'false') {
        return colors.grey1;
      }

      return (condition.parameters!.passed == 'false')
          ? colors.blue
          : colors.black;
    }
  } else {
    return (condition.parameters!.passed == 'false')
        ? colors.blue
        : colors.black;
  }
}
