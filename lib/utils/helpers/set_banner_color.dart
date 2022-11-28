import 'package:flutter/material.dart';
import 'package:jetwallet/features/rewards/model/campaign_or_referral_model.dart';

const _inviteFriend = 'InviteFriend';
const _earnLanding = 'EarnLanding';

// Colors for banners
const bannersColor = [
  Color(0xFFE0E3FA),
  Color(0xFFD5F4F4),
  Color(0xFFE8F9E8),
  Color(0xFFFAF3E0),
];

Color setBannerColor(CampaignOrReferralModel item) {
  if (item.campaign!.deepLink.contains(_inviteFriend)) {
    return bannersColor[0];
  } else if (item.campaign!.deepLink.contains(_earnLanding)) {
    return bannersColor[1];
  }

  return bannersColor[2];
}
