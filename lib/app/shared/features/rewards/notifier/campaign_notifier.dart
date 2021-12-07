import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/campaign/model/campaign_model.dart';
import '../../../../../shared/logging/levels.dart';
import 'campaign_state.dart';

class CampaignNotifier extends StateNotifier<CampaignState> {
  CampaignNotifier({
    required this.read,
  }) : super(const CampaignState(campaigns: <CampaignModel>[]));

  final Reader read;

  static final _logger = Logger('CampaignNotifier');

  void updateCampaigns(List<CampaignModel> campaigns) {
    _logger.log(notifier, 'updateCampaigns');

    state = state.copyWith(campaigns: campaigns);
  }

  void deleteCampaign(CampaignModel campaign) {
    _logger.log(notifier, 'deleteCampaign');

    final newList = List<CampaignModel>.from(state.campaigns);
    newList.remove(campaign);
    state = state.copyWith(campaigns: newList);
  }
}
