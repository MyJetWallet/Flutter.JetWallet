import 'package:freezed_annotation/freezed_annotation.dart';

import 'additional_prop_model.dart';
import 'reward_model.dart';

part 'campaign_condition_model.freezed.dart';
part 'campaign_condition_model.g.dart';


@freezed
class CampaignConditionModel with _$CampaignConditionModel {
  const factory CampaignConditionModel({
    required int type,
    AdditionalPropModel? params,
    RewardModel? reward,
  }) = _CampaignConditionModel;


  // factory CampaignConditionModel.fromList(List list) {
  //   return CampaignConditionModel(
  //     params: list
  //         .map((e) => AdditionalPropModel.fromJson(e as Map<String, dynamic>))
  //         .toList(),
  //   );
  // }

factory CampaignConditionModel.fromJson(Map<String, dynamic> json) =>
    _$CampaignConditionModelFromJson(json);
}
