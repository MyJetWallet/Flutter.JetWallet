import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    height: 24.r,
    width: 24.r,
    child: (condition.parameters!.passed == 'true')
        ? const SCompleteIcon()
        : const SBlueRightArrowIcon(),
  );
}
