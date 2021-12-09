import '../../../../../service/services/signal_r/model/campaign_response_model.dart';

import '../model/condition_type.dart';

String setRewardDescriptionItem(
  CampaignConditionModel condition,
) {
  if (condition.type == conditionTypeSwitch(ConditionType.kYCCondition)) {
    return 'Get \$${condition.reward!.amount} for account verification';
  } else if (condition.type ==
      conditionTypeSwitch(ConditionType.depositCondition)) {
    return 'Get \$${condition.reward!.amount} after making first deposit';
  } else if (condition.type ==
      conditionTypeSwitch(ConditionType.tradeCondition)) {
    return '\$${condition.reward!.amount} after trading \$100 (${condition.parameters!.tradedAmount}/${condition.parameters!.requiredAmount})';
  } else {
    return '';
  }
}
