import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/campaign/model/campaign_condition_model.dart';
import '../model/condition_type.dart';

TextStyle setRewardDescriptionStyle(
    CampaignConditionModel condition,
    List<CampaignConditionModel> conditions,
    SimpleColors colors,
    ) {
  if (conditions.length > 1) {
    if (condition.type == ConditionType.kYCCondition.value) {
      return TextStyle(
        color: (condition.params!.passed == 'false')
            ? colors.blue
            : colors.black,
      );
    } else {
      final currentIndexCondition = conditions.indexOf(condition);
      final prevCondition = conditions[currentIndexCondition - 1];

      if (prevCondition.params!.passed == 'false') {
        return TextStyle(
          color: colors.grey1,
        );
      }

      return TextStyle(
        color: (condition.params!.passed == 'false')
            ? colors.blue
            : colors.black,
      );
    }
  } else {
    return TextStyle(
      color:
      (condition.params!.passed == 'false') ? colors.blue : colors.black,
    );
  }
}