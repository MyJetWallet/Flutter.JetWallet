import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../service/services/campaign/model/campaign_model.dart';

part 'campaign_state.freezed.dart';

@freezed
class CampaignState with _$CampaignState {
  const factory CampaignState({
    required List<CampaignModel> campaigns,
  }) = _CampaignState;
}
