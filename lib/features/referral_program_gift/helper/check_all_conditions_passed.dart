import 'package:simple_networking/modules/signal_r/models/campaign_response_model.dart';

bool checkAllReferralConditionsPassed(
  List<CampaignConditionModel> conditions,
) {
  for (final condition in conditions) {
    if (condition.parameters!.passed == 'false') {
      return false;
    }
  }

  return true;
}
