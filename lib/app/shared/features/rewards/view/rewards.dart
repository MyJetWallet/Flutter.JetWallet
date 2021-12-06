import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/rewards/model/condition_type.dart';
import 'package:jetwallet/service/services/campaign/model/campaign_condition_model.dart';
import 'package:jetwallet/service/services/campaign/model/campaign_model.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/loaders/loader.dart';
import '../../../helpers/set_banner_colors.dart';
import '../../market_details/helper/format_news_date.dart';
import '../helpers/create_reward_detail.dart';
import '../notifier/campaign_notipod.dart';
import '../providers/campaigns_fpod.dart';

class Rewards extends HookWidget {
  const Rewards({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final campaignsInit = useProvider(campaignsInitFpod);
    final campaign = useProvider(campaignNotipod);
    final campaignN = useProvider(campaignNotipod.notifier);
    final colors = useProvider(sColorPod);

    return campaignsInit.when(
      data: (_) {
        return SPageFrameWithPadding(
          header: SSmallHeader(
            title: 'Rewards',
            onBackButtonTap: () => Navigator.pop(context),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  if (index == 0) const SpaceH20(),
                  if (campaign.campaigns[index].conditions == null) ...[
                    SRewardBanner(
                      bannerColor: setBannerColor(index, colors),
                      primaryText: campaign.campaigns[index].title,
                      secondaryText: campaign.campaigns[index].description,
                      imageUrl: campaign.campaigns[index].imageUrl,
                    ),
                  ],
                  if (campaign.campaigns[index].conditions != null) ...[
                    SThreeStepsRewardBanner(
                      primaryText: campaign.campaigns[index].title,
                      timeToComplete: formatBannersDate(
                        campaign.campaigns[index].timeToComplete,
                      ),
                      imageUrl: campaign.campaigns[index].imageUrl,
                      circleAvatarColor: setBannerColor(index, colors),
                      rewardDetail: createRewardDetail(
                        campaign.campaigns[index].conditions!,
                      ),
                      rewardIndicatorComplete: setRewardIndicatorComplete(
                        campaign.campaigns[index].conditions!,
                        colors,
                      ),
                    ),
                  ],
                ],
              );

              // return SMarketBanner(
              //   primaryText: data.campaigns[index].title,
              //   imageUrl: data.campaigns[index].imageUrl,
              //   bannerColor: colors.violet,
              //   onClose: () {
              //     print('CLOSE ${data.campaigns[index].title}');
              //   },
              // );
            },
            itemCount: campaign.campaigns.length,
          ),
        );
      },
      loading: () => const Scaffold(body: Loader()),
      error: (_, __) => Scaffold(body: Container()),
    );
  }

  Widget? setRewardIndicatorComplete(
      List<CampaignConditionModel> conditions, SimpleColors colors) {
    var completeIndicator = 0;
    var isDisplayIndicator = false;

    for (final condition in conditions) {
      if (condition.params!.passed == 'true') {
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
                // padding: EdgeInsets.only(left: 20.w,),
                decoration: BoxDecoration(
                  color: SColorsLight().blueLight,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              Positioned(
                child: Container(
                  width: (completeIndicator == 0)
                      ? 80.w
                      : (completeIndicator == 1)
                          ? 80.w
                          : (completeIndicator == 2)
                              ? 160.w
                              : 240.w,
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      bottomLeft: Radius.circular(16.r),
                      topRight: (completeIndicator == conditions.length)
                          ? Radius.circular(16.r)
                          : Radius.zero,
                      bottomRight: (completeIndicator == conditions.length)
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
}
