import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../helpers/set_banner_colors.dart';
import '../../market_details/helper/format_news_date.dart';
import 'create_reward_detail.dart';
import 'set_reward_indicator_complete.dart';

Widget createRewardBanner(
    CampaignModel item,
    SimpleColors colors,
    ) {
  final randomNumber = Random();
  if (item.conditions == null ||
      (item.conditions != null &&
          item.conditions!.isEmpty)) {
    return SRewardBanner(
      color: setBannerColor(
        randomNumber.nextInt(3),
        colors,
      ),
      primaryText: item.title,
      secondaryText: item.description,
      imageUrl: item.imageUrl,
    );
  } else if (item.conditions != null && item.conditions!.isNotEmpty) {
    return SThreeStepsRewardBanner(
      primaryText: item.title,
      timeToComplete: formatBannersDate(
        item.timeToComplete,
      ),
      imageUrl: item.imageUrl,
      circleAvatarColor: setBannerColor(
        randomNumber.nextInt(3),
        colors,
      ),
      rewardDetail: createRewardDetail(
        item.conditions!,
      ),
      rewardIndicatorComplete: setRewardIndicatorComplete(
        item.conditions!,
        colors,
      ),
    );
  } else {
    return const SizedBox();
  }
}
