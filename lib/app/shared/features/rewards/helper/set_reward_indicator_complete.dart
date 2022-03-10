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

    if (condition.type == conditionTypeSwitch(ConditionType.tradeCondition)) {
      isDisplayIndicator = true;
    }
  }

  if (isDisplayIndicator) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
                width: _setIndicatorValue(completeIndicator, conditions.length),
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

        Container(
          padding: const EdgeInsets.only(right: 17.0),
          child: Text('$completeIndicator/${conditions.length}'),
        ),
      ],
    );
  } else {
    return null;
  }
}

double _setIndicatorValue(int completeIndicator, int conditionsLength) {
  final step = 240 / conditionsLength;

  if (completeIndicator == 0) {
    return 0.0;
  }

  return step * completeIndicator;
}

bool _setBorderRadius(completeIndicator, int conditionsLength) {
  return completeIndicator == conditionsLength;
}
