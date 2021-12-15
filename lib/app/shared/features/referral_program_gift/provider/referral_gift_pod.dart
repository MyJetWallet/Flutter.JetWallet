import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../referral_stats/provider/referral_stats_pod.dart';
import '../../rewards/notifier/campaign_notipod.dart';

const referralStatsTotal = 15;

final referralGiftPod = Provider.autoDispose<ReferralGiftStatus>(
  (ref) {
    final campaigns = ref.watch(campaignNotipod(false));
    final referralStats = ref.watch(referralStatsPod);
    final referralGiftService = ref.read(referralGiftServicePod);

    final referralProgramExist =
        referralGiftService.findReferralProgram(campaigns);

    if (referralProgramExist.isNotEmpty) {
      return referralGiftService.checkAllReferralConditionsPassed(
        referralProgramExist[0].conditions!,
      )
          ? ReferralGiftStatus.hideGift
          : ReferralGiftStatus.showGift;
    } else {
      if (referralStats.isNotEmpty &&
          referralStats[0].total < referralStatsTotal) {
        return ReferralGiftStatus.showGift;
      }
      return ReferralGiftStatus.hideGift;
    }
  },
);

enum ReferralGiftStatus {
  showGift,
  hideGift,
}
