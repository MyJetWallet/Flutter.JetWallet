import '../../../../../service/services/signal_r/model/campaign_response_model.dart';

bool isConditionNotExist(CampaignModel item) {
  return item.conditions == null ||
      (item.conditions != null &&
          item.conditions!.isEmpty);
}
