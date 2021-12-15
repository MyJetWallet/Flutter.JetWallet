import 'package:logging/logging.dart';

import '../../signal_r/model/campaign_response_model.dart';
import 'services/check_all_conditions_passed_service.dart';
import 'services/find_referral_program_service.dart';

class ReferralGiftService {
  static final logger = Logger('ReferralGiftService');

  bool checkAllReferralConditionsPassed(
    List<CampaignConditionModel> conditions,
  ) {
    return checkAllReferralConditionsPassedService(conditions);
  }

  List<CampaignModel> findReferralProgram(List<CampaignModel> campaigns) {
    return findReferralProgramService(campaigns);
  }
}
