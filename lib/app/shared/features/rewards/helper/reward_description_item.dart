import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/signal_r/model/campaign_response_model.dart';

import '../../../../../shared/providers/deep_link_service_pod.dart';
import '../../../../../shared/providers/device_size/media_query_pod.dart';
import '../../../../../shared/services/deep_link_service.dart';
import 'set_reward_description_item.dart';
import 'set_reward_icon.dart';

class RewardsDescriptionItem extends HookWidget {
  const RewardsDescriptionItem({
    Key? key,
    required this.condition,
    required this.conditions,
  }) : super(key: key);

  final CampaignConditionModel condition;
  final List<CampaignConditionModel> conditions;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final deepLinkService = useProvider(deepLinkServicePod);
    final mediaQuery = useProvider(mediaQueryPod);

    return Container(
      margin: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Column(
        children: [
          Container(
            margin: (condition == conditions.first)
                ? EdgeInsets.zero
                : const EdgeInsets.only(top: 2),
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
                      SourceScreen.bannerOnRewards,
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
