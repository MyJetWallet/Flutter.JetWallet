import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';

Widget setRewardIcon(
  CampaignConditionModel condition,
  List<CampaignConditionModel> conditions,
) {
  final currentIndexCondition = conditions.indexOf(condition);
  if (currentIndexCondition > 0) {
    final prevCondition = conditions[currentIndexCondition - 1];
    if (prevCondition.parameters!.passed == 'false') {
      return const SizedBox();
    }
  }

  return SizedBox(
    height: 24.0,
    width: 24.0,
    child: (condition.parameters!.passed == 'true')
        ? const SCompleteIcon()
        : const SBlueRightArrowIcon(),
  );
}
