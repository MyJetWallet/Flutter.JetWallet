import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import '../../../../../service/services/campaign/model/campaign_response_model.dart';

class AccountBannersList extends HookWidget {
  const AccountBannersList({
    Key? key,
    required this.campaigns,
  }) : super(key: key);

  final CampaignResponseModel campaigns;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return SizedBox(
      height: 0.25.sh,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (int i = 0; i < campaigns.campaigns.length; i++) ...[
            if (i == 0) const SpaceW20(),
            SAccountBanner(
              bannerColor: colors.violet,
              primaryText: campaigns.campaigns[i].title,
              secondaryText: campaigns.campaigns[i].description,
              imageUrl: campaigns.campaigns[i].imageUrl,
              onClose: () {},
            ),
            if (i == campaigns.campaigns.length - 1) ...[const SpaceW20()],
            if (i != campaigns.campaigns.length - 1) ...[const SpaceW10()],
          ],
        ],
      ),
    );
  }
}
