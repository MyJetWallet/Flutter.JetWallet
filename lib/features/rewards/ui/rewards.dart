import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/format_news_date.dart';
import 'package:jetwallet/features/rewards/store/reward_store.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/helpers/set_banner_color.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';

import '../../../core/services/key_value_service.dart';
import '../../../utils/constants.dart';
import '../helper/create_reward_detail.dart';
import '../helper/set_reward_indicator_complete.dart';
import '../model/campaign_or_referral_model.dart';

class Rewards extends StatelessWidget {
  const Rewards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<RewardStore>(
      create: (context) => RewardStore(),
      builder: (context, child) => const _RewardsBody(),
    );
  }
}

class _RewardsBody extends StatelessObserverWidget {
  const _RewardsBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;
    final baseCurrency = sSignalRModules.baseCurrency;

    final state = RewardStore.of(context);
    final deepLinkService = getIt.get<DeepLinkService>();
    final viewedRewards = sSignalRModules.keyValue.viewedRewards?.value
        ?? <String>[];

    final mediaQuery = MediaQuery.of(context);

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.rewards_rewards,
        ),
      ),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          const SpaceH20(),
          if (state.sortedCampaigns.isNotEmpty)
            const SPaddingH24(child: SDivider()),
          for (final item in state.sortedCampaigns) ...[
            if (_displayRewardBanner(item)) ...[
              SRewardBanner(
                color: !viewedRewards.contains(item.campaign!.campaignId)
                    ? colors.grey5
                    : Colors.transparent,
                primaryText: item.campaign!.title,
                secondaryText: item.campaign!.description,
                imageUrl: item.campaign!.imageUrl,
                onTap: () {
                  if (!viewedRewards.contains(item.campaign!.campaignId)) {
                    getIt.get<KeyValuesService>().addToKeyValue(
                      KeyValueRequestModel(
                        keys: [
                          KeyValueResponseModel(
                            key: viewedRewardsKey,
                            value: jsonEncode([...viewedRewards, item.campaign!.campaignId]),
                          ),
                        ],
                      ),
                    );
                  }
                  deepLinkService.handle(
                    Uri.parse(item.campaign!.deepLink),
                    source: SourceScreen.bannerOnRewards,
                  );
                },
                isActive: !viewedRewards.contains(item.campaign!.campaignId),
              ),
            ],
            if (_displayThreeStepsRewardBanner(item)) ...[
              SPaddingH24(
                child: SThreeStepsRewardBanner(
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
                    sRouter.push(
                      InfoWebViewRouter(
                        link: infoRewardsLink,
                        title: intl.rewards_rewards,
                      ),
                    );
                  },
                  showInfoIcon: infoRewardsLink.isNotEmpty,
                ),
              ),
            ],
            if (_displayReferralStats(item)) ...[
              const SpaceH32(),
              SPaddingH24(
                child: SReferralStats(
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
                  referralStatsText: intl.rewards_referralStats,
                  referralsInvitedText: intl.rewards_referralsInvited,
                  referralsActivatedText: intl.rewards_referralActivated,
                  bonusEarnedText: intl.rewards_bonusEarned,
                  commissionEarnedText: intl.rewards_commissionEarned,
                  totalText: intl.rewards_total,
                  currencySymbol: baseCurrency.symbol,
                  currencyPrefix: baseCurrency.prefix,
                ),
              ),
            ],
          ],
          const SpaceH42(),
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
