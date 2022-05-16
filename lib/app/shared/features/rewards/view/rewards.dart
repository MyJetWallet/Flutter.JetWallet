import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/launch_url.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/providers/deep_link_service_pod.dart';
import '../../../../../shared/providers/device_size/media_query_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/services/deep_link_service.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../components/info_web_view.dart';
import '../../../helpers/set_banner_color.dart';
import '../../market_details/helper/format_news_date.dart';
import '../helper/create_reward_detail.dart';
import '../helper/set_reward_indicator_complete.dart';
import '../model/campaign_or_referral_model.dart';
import '../notifier/reward/rewards_notipod.dart';

class Rewards extends HookWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(rewardsNotipod);
    final deepLinkService = useProvider(deepLinkServicePod);
    final mediaQuery = useProvider(mediaQueryPod);

    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: intl.rewards,
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SpaceH20(),
          for (final item in state.sortedCampaigns) ...[
            if (_displayThreeStepsRewardBanner(item)) ...[
              SThreeStepsRewardBanner(
                primaryText: item.campaign!.title,
                timeToComplete: formatBannersDate(
                  item.campaign!.timeToComplete,
                  context,
                ),
                imageUrl: item.campaign!.imageUrl,
                rewardDetail: createRewardDetail(
                  item.campaign!.conditions!,
                ),
                rewardIndicatorComplete: setRewardIndicatorComplete(
                  item.campaign!.conditions!,
                  colors,
                  mediaQuery.size.width - 130,
                ),
                onTap: () {
                  navigatorPush(
                    context,
                    InfoWebView(
                      link: infoRewardsLink,
                      title: intl.rewards,
                    ),
                  );
                },
                showInfoIcon: infoRewardsLink.isNotEmpty,
              ),
              const SpaceH20(),
            ],
            if (_displayRewardBanner(item)) ...[
              SRewardBanner(
                color: setBannerColor(item),
                primaryText: item.campaign!.title,
                secondaryText: item.campaign!.description,
                imageUrl: item.campaign!.imageUrl,
                onTap: () {
                  deepLinkService.handle(
                    Uri.parse(item.campaign!.deepLink),
                    SourceScreen.bannerOnRewards,
                  );
                },
              ),
              const SpaceH20(),
            ],
            if (_displayReferralStats(item)) ...[
              SReferralStats(
                referralInvited: item.referralState!.referralInvited,
                referralActivated: item.referralState!.referralActivated,
                bonusEarned: item.referralState!.bonusEarned.toDouble(),
                commissionEarned:
                    item.referralState!.commissionEarned.toDouble(),
                total: item.referralState!.total.toDouble(),
                showReadMore: item.referralState!.descriptionLink.isNotEmpty,
                onInfoTap: () {
                  launchURL(
                    context,
                    item.referralState!.descriptionLink,
                  );
                },
                referralStatsText: intl.referralStats,
                referralsInvitedText: intl.referralsInvited,
                referralsActivatedText: intl.referralActivated,
                bonusEarnedText: intl.bonusEarned,
                commissionEarnedText: intl.commissionEarned,
                totalText: intl.total,
              ),
              const SpaceH20(),
            ],
          ],
        ],
      ),
    );
  }

  bool _displayThreeStepsRewardBanner(CampaignOrReferralModel item) {
    if (item.campaign == null) {
      return false;
    }

    return item.campaign!.conditions != null &&
        (item.campaign!.conditions != null &&
            item.campaign!.conditions!.isNotEmpty);
  }

  bool _displayRewardBanner(CampaignOrReferralModel item) {
    if (item.campaign == null) {
      return false;
    }

    return item.campaign!.conditions == null ||
        (item.campaign!.conditions != null &&
            item.campaign!.conditions!.isEmpty);
  }

  bool _displayReferralStats(CampaignOrReferralModel item) {
    if (item.referralState == null) {
      return false;
    }
    return true;
  }
}
