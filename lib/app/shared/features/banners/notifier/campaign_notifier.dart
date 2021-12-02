import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/campaign/model/campaign_model.dart';
import 'campaign_state.dart';

class CampaignNotifier extends StateNotifier<CampaignState> {
  CampaignNotifier({
    required this.read,
  }) : super(const CampaignState(campaigns: <CampaignModel>[]));

  final Reader read;

  static final _logger = Logger('CampaignNotifier');
}
