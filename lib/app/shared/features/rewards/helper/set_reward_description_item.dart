import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/campaign_response_model.dart';

import 'set_reward_description_style.dart';

Widget createRewardDescriptionItem(
  CampaignConditionModel condition,
  List<CampaignConditionModel> conditions,
  SimpleColors colors,
  double width,
  Function(String) onTap,
) {
  return GestureDetector(
    onTap: () {
      if (condition.parameters!.passed == 'false') {
        onTap(condition.deepLink);
      }
    },
    child: SizedBox(
      width: width,
      child: Text(
        condition.description,
        maxLines: 2,
        style: sBodyText1Style.copyWith(
          height: 1.30,
          color: setRewardDescriptionStyle(
            condition,
            conditions,
            colors,
          ),
        ),
      ),
    ),
  );
}
