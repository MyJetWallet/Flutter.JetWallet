import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
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

    // conditionTypeSwitch(ConditionType.tradeCondition);

    if (condition.type == conditionTypeSwitch(ConditionType.tradeCondition)) {
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
              width: 240.0,
              height: 16.0,
              decoration: BoxDecoration(
                color: colors.grey4,
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            Positioned(
              child: Container(
                width: _setIndicatorValue(completeIndicator),
                height: 16.0,
                decoration: BoxDecoration(
                  color: colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16.0),
                    bottomLeft: const Radius.circular(16.0),
                    topRight:
                        _setBorderRadius(completeIndicator, conditions.length)
                            ? const Radius.circular(16.0)
                            : Radius.zero,
                    bottomRight:
                        _setBorderRadius(completeIndicator, conditions.length)
                            ? const Radius.circular(16.0)
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
      ? 0.0
      : (completeIndicator == 1)
          ? 80.0
          : (completeIndicator == 2)
              ? 160.0
              : 240.0;
}

bool _setBorderRadius(completeIndicator, int conditionsLength) {
  return completeIndicator == conditionsLength;
}
