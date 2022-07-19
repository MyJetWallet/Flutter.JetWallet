import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../model/campaign_or_referral_model.dart';

Widget setRewardIcon(
  CampaignConditionModel condition,
  List<CampaignConditionModel> conditions,
) {
  final currentIndexCondition = conditions.indexOf(condition);
  if (currentIndexCondition > 0) {
    final prevCondition = conditions[currentIndexCondition - 1];

    if (prevCondition.parameters == null) {
      return const SizedBox();
    }
    if (prevCondition.parameters!.passed == 'false') {
      return const SizedBox();
    }
  }

  return Container(
    margin: const EdgeInsets.only(right: 17.0),
    height: 24.0,
    width: 24.0,
    child: condition.parameters != null
        ? (condition.parameters!.passed == 'true')
            ? const SCompleteIcon()
            : const SBlueRightArrowIcon()
        : const SBlueRightArrowIcon(),
  );
}
