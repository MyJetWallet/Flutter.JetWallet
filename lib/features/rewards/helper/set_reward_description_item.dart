import 'package:flutter/material.dart';
import 'package:jetwallet/features/rewards/helper/set_reward_description_style.dart';
import 'package:simple_kit/simple_kit.dart';

import '../model/campaign_or_referral_model.dart';

Widget createRewardDescriptionItem(
  CampaignConditionModel condition,
  List<CampaignConditionModel> conditions,
  SimpleColors colors,
  double width,
  Function(String) onTap,
) {
  if (condition.parameters == null) {
    return const SizedBox();
  }

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
