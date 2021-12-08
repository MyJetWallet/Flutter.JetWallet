import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import 'package:simple_kit/simple_kit.dart';

import '../model/condition_type.dart';

Widget? setRewardIndicatorComplete(
  List<CampaignConditionModel> conditions,
  SimpleColors colors,
) {
  var completeIndicator = 0;
  var isDisplayIndicator = false;

  for (final condition in conditions) {
    if (condition.parameters!.passed == 'true') {
      completeIndicator += 1;
    }
    if (condition.type == ConditionType.tradeCondition.value) {
      isDisplayIndicator = true;
    }
  }

  if (isDisplayIndicator) {
    return Row(
      children: [
        const SpaceW20(),
        Stack(
          children: <Widget>[
            Container(
              width: 240.w,
              height: 16.h,
              decoration: BoxDecoration(
                color: colors.grey4,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            Positioned(
              child: Container(
                width: _setIndicatorValue(completeIndicator),
                height: 16.h,
                decoration: BoxDecoration(
                  color: colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.r),
                    bottomLeft: Radius.circular(16.r),
                    topRight:
                        _setBorderRadius(completeIndicator, conditions.length)
                            ? Radius.circular(16.r)
                            : Radius.zero,
                    bottomRight:
                        _setBorderRadius(completeIndicator, conditions.length)
                            ? Radius.circular(16.r)
                            : Radius.zero,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SpaceW24(),
        Text('$completeIndicator/${conditions.length}'),
      ],
    );
  } else {
    return null;
  }
}

double _setIndicatorValue(int completeIndicator) {
  return (completeIndicator == 0)
      ? 0.w
      : (completeIndicator == 1)
          ? 80.w
          : (completeIndicator == 2)
              ? 160.w
              : 240.w;
}

bool _setBorderRadius(completeIndicator, int conditionsLength) {
  return completeIndicator == conditionsLength;
}
