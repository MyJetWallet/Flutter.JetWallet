import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../model/condition_type.dart';

TextStyle setRewardDescriptionStyle(
  CampaignConditionModel condition,
  List<CampaignConditionModel> conditions,
  SimpleColors colors,
) {
  if (conditions.length > 1) {
    if (condition.type == conditionTypeSwitch(ConditionType.kYCCondition)) {
      final textStyle = TextStyle(
        color: (condition.parameters!.passed == 'false')
            ? colors.blue
            : colors.black,
      );
      return textStyle;
    } else {
      final currentIndexCondition = conditions.indexOf(condition);
      if (currentIndexCondition > 0) {
        final prevCondition = conditions[currentIndexCondition - 1];
        if (prevCondition.parameters!.passed == 'false') {
          return TextStyle(
            color: colors.grey1,
          );
        }
      }
      return TextStyle(
        color: (condition.parameters!.passed == 'false')
            ? colors.blue
            : colors.black,
      );
    }
  } else {
    return TextStyle(
      color: (condition.parameters!.passed == 'false')
          ? colors.blue
          : colors.black,
    );
  }
}
