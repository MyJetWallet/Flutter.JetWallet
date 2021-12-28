import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../model/condition_type.dart';

Color setRewardDescriptionStyle(
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
      if (currentIndexCondition > 0) {
        final prevCondition = conditions[currentIndexCondition - 1];
        if (prevCondition.parameters!.passed == 'false') {
          return colors.grey1;
        }
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
