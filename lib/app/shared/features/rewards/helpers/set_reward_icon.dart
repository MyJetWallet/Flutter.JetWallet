import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

import '../model/campaign_condition_model.dart';

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
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 5.h,
        horizontal: 7.75.h,
      ),
      height: 24.r,
      width: 24.r,
      child: const SBlueRightArrowIcon(),
    );
  }
}
