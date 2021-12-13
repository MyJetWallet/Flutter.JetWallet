import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/shared/features/phone_verification/phone_verification_enter/components/phone_number_bottom_sheet.dart';
import 'package:jetwallet/shared/features/phone_verification/phone_verification_enter/components/phone_number_search.dart';
import 'package:jetwallet/shared/notifiers/user_info_notifier/user_info_notipod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/features/rewards/notifier/campaign_notipod.dart';
import '../../../../../shared/helpers/set_banner_colors.dart';

class MarketBanner extends HookWidget {
  const MarketBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final campaign = useProvider(campaignNotipod(true));
    final campaignN = useProvider(campaignNotipod(true).notifier);
    final colors = useProvider(sColorPod);
    final userInfo = useProvider(userInfoNotipod);

    if (campaign.isNotEmpty) {
      return SizedBox(
        height: 120,
        child: ListView.builder(
          itemCount: campaign.length,
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            bottom: 10,
          ),
          itemBuilder: (BuildContext context, int index) => GestureDetector(
            onTap: () {
              sShowBasicModalBottomSheet(
                context: context,
                removeBottomHeaderPadding: true,
                removeBottomSheetBar: true,
                removeTopHeaderPadding: true,
                horizontalPinnedPadding: 0,
                scrollable: true,
                pinned: const SReferralInvitePinned(),
                children: [
                  SReferralInviteBody(
                    primaryText: campaign[index].title,
                    referralCode: userInfo.referralCode,
                    onReadMoreTap: () {
                      print('onReadMoreTap');
                    },
                  ),
                ],
              );
            },
            child: Container(
              padding: EdgeInsets.only(
                right: (index != campaign.length - 1) ? 10 : 0,
              ),
              child: SRewardBanner(
                color: setBannerColor(index, colors),
                primaryText: campaign[index].title,
                imageUrl: campaign[index].imageUrl,
                primaryTextStyle: sTextH5Style,
                onClose: () {
                  campaignN.deleteCampaign(campaign[index]);
                },
              ),
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
