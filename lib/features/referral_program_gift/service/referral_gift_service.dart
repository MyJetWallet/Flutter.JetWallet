import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/referral_program_gift/helper/check_all_conditions_passed.dart';
import 'package:jetwallet/features/referral_program_gift/helper/find_referral_program.dart';
import 'package:jetwallet/features/rewards/store/reward_campaign_store.dart';

const referralStatsTotal = 15;

enum ReferralGiftStatus {
  showGift,
  hideGift,
}

ReferralGiftStatus referralGift() {
  final campaigns = RewardCampaignStore(false);
  final referralStats = sSignalRModules.referralStats;

  final referralProgramExist = findReferralProgram(campaigns.campaigns);

  if (referralProgramExist.isNotEmpty) {
    return checkAllReferralConditionsPassed(
      referralProgramExist[0].conditions!,
    )
        ? ReferralGiftStatus.hideGift
        : ReferralGiftStatus.showGift;
  } else {
    if (referralStats.isNotEmpty && referralStats[0].total < Decimal.parse(referralStatsTotal.toString())) {
      return ReferralGiftStatus.showGift;
    }

    return ReferralGiftStatus.hideGift;
  }
}
