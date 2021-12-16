import '../../../../../service/services/signal_r/model/campaign_response_model.dart';

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
