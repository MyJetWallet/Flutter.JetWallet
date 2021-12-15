import '../../../signal_r/model/campaign_response_model.dart';

bool checkAllReferralConditionsPassedService(
  List<CampaignConditionModel> conditions,
) {
  for (final condition in conditions) {
    if (condition.parameters!.passed == 'false') {
      return false;
    }
  }
  return true;
}
