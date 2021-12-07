import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/services/local_storage_service.dart';
import '../model/campaign_model.dart';
import 'campaign_state.dart';

class CampaignNotifier extends StateNotifier<CampaignState> {
  CampaignNotifier({
    this.isEnableFilterBanners = false,
    required this.read,
    required this.campaigns,
  }) : super(const CampaignState(campaigns: <CampaignModel>[])) {
    storage = read(localStorageServicePod);

    updateCampaigns(campaigns);

    if (isEnableFilterBanners) {
      _filteredBanners();
    }
  }

  final Reader read;
  final bool isEnableFilterBanners;
  final List<CampaignModel> campaigns;
  late LocalStorageService storage;

  static final _logger = Logger('CampaignNotifier');

  void updateCampaigns(List<CampaignModel> campaigns) {
    _logger.log(notifier, 'updateCampaigns');

    try {
      if (campaigns.isNotEmpty) {
        state = state.copyWith(campaigns: campaigns);
      }
    } catch (e) {
      _logger.log(stateFlow, 'updateCampaigns', e);
    }
  }

  Future<void> deleteCampaign(CampaignModel campaign) async {
    _logger.log(notifier, 'deleteCampaign');

    try {
      final newList = List<CampaignModel>.from(state.campaigns);
      newList.remove(campaign);
      await _setBannersIdsToStorage(campaign.campaignId);
      state = state.copyWith(campaigns: newList);
    } catch (e) {
      _logger.log(stateFlow, 'deleteCampaign', e);
    }
  }

  Future<void> _filteredBanners() async {
    _logger.log(notifier, '_filteredBanners');

    try {
      final bannersIds = await _getBannersIdsFromStorage();
      final _existedBanners = <CampaignModel>[];

      if (bannersIds.isNotEmpty && state.campaigns.isNotEmpty) {
        for (final id in bannersIds) {
          for (final campaign in state.campaigns) {
            if (id == campaign.campaignId) {
              _existedBanners.add(campaign);
            }
          }
        }

        if (_existedBanners.isNotEmpty) {
          for (final banner in _existedBanners) {
            await _deleteCampaignWithOutAddToStorage(banner);
          }
        }
      }
    } catch (e) {
      _logger.log(stateFlow, '_filteredBanners', e);
    }
  }

  Future<void> _setBannersIdsToStorage(String bannerId) async {
    _logger.log(notifier, '_setBannersIdsToStorage');

    try {
      final bannersIds = await _getBannersIdsFromStorage();

      if (bannersIds.isNotEmpty) {
        await storage.setStringArray('bannersIds', [...bannersIds, bannerId]);
      } else {
        await storage.setStringArray('bannersIds', [bannerId]);
      }
    } catch (e) {
      _logger.log(stateFlow, '_setBannersIdsToStorage', e);
    }
  }

  Future<List<String>> _getBannersIdsFromStorage() async {
    _logger.log(notifier, '_getBannersIdsFromStorage');

    try {
      final bannersIds = await storage.getStringArray('bannersIds');
      if (bannersIds != null) {
        final ids = jsonDecode(bannersIds);
        final arrayIds = (ids as List).map((item) => item as String).toList();
        return arrayIds;
      } else {
        return <String>[];
      }
    } catch (e) {
      _logger.log(stateFlow, '_getBannersIdsFromStorage', e);
      return <String>[];
    }
  }

  Future<void> _deleteCampaignWithOutAddToStorage(
    CampaignModel campaign,
  ) async {
    _logger.log(notifier, '_deleteCampaignWithOutAddToStorage');

    try {
      final newList = List<CampaignModel>.from(state.campaigns);
      newList.remove(campaign);
      state = state.copyWith(campaigns: newList);
    } catch (e) {
      _logger.log(stateFlow, '_deleteCampaignWithOutAddToStorage', e);
    }
  }
}
