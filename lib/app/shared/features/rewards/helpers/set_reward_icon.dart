import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/campaign/model/campaign_condition_model.dart';

Widget setRewardIcon(
    CampaignConditionModel condition,
    List<CampaignConditionModel> conditions,
    ) {
  final currentIndexCondition = conditions.indexOf(condition);
  if (currentIndexCondition > 0) {
    final prevCondition = conditions[currentIndexCondition - 1];
    if (prevCondition.params!.passed == 'false') {
      return const SizedBox();
    }
  }
  if (condition.params!.passed == 'true') {
    return SizedBox(
      height: 24.r,
      width: 24.r,
      child: const SCompleteIcon(),
    );
  } else {
    return SizedBox(
      height: 14.r,
      width: 8.5.r,
      child: const SBlueRightArrowIcon(),
    );
  }
}