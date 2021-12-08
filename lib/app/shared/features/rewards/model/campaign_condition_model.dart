import 'package:freezed_annotation/freezed_annotation.dart';

import 'campaign_condition_parameters_model.dart';
import 'reward_model.dart';

part 'campaign_condition_model.freezed.dart';
part 'campaign_condition_model.g.dart';


@freezed
class CampaignConditionModel with _$CampaignConditionModel {
  const factory CampaignConditionModel({
    @JsonKey(name: 'params') CampaignConditionParametersModel? parameters,
    RewardModel? reward,
    required int type,
  }) = _CampaignConditionModel;

factory CampaignConditionModel.fromJson(Map<String, dynamic> json) =>
    _$CampaignConditionModelFromJson(json);
}
