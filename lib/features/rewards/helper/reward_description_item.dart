import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/features/rewards/helper/set_reward_description_item.dart';
import 'package:jetwallet/features/rewards/helper/set_reward_icon.dart';
import 'package:jetwallet/features/rewards/model/campaign_or_referral_model.dart';
import 'package:simple_kit/core/simple_kit.dart';

class RewardsDescriptionItem extends StatelessObserverWidget {
  const RewardsDescriptionItem({
    super.key,
    required this.condition,
    required this.conditions,
  });

  final CampaignConditionModel condition;
  final List<CampaignConditionModel> conditions;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final deepLinkService = getIt.get<DeepLinkService>();
    final mediaQuery = MediaQuery.of(context);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Column(
        children: [
          Container(
            margin: (condition == conditions.first) ? EdgeInsets.zero : const EdgeInsets.only(top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                createRewardDescriptionItem(
                  condition,
                  conditions,
                  colors,
                  mediaQuery.size.width - 130,
                  (String deepLink) {
                    deepLinkService.handle(
                      Uri.parse(deepLink),
                      source: SourceScreen.bannerOnRewards,
                    );
                  },
                ),
                setRewardIcon(condition, conditions),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
