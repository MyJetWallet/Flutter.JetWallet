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
    this.isFilterEnabled = false,
    required this.read,
    required this.campaigns,
  }) : super(const CampaignState(campaigns: <CampaignModel>[])) {
    storage = read(localStorageServicePod);
    updateCampaigns(campaigns);
  }

  final Reader read;
  final bool isFilterEnabled;
  final List<CampaignModel> campaigns;
  late LocalStorageService storage;

  static final _logger = Logger('CampaignNotifier');

  Future<void> updateCampaigns(List<CampaignModel> campaigns) async {
    _logger.log(notifier, 'updateCampaigns');

    final validCampaigns = <CampaignModel>[
      if (isFilterEnabled)
        ...await _filteredBanners(campaigns)
      else
        ...campaigns
    ];

    state = state.copyWith(campaigns: validCampaigns);
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

  Future<List<CampaignModel>> _filteredBanners(
    List<CampaignModel> campaigns,
  ) async {
    _logger.log(notifier, '_filteredBanners');

    final _bannersForRemove = <CampaignModel>[];

    try {
      final storageBannerIds = await _getBannersIdsFromStorage();
      if (storageBannerIds.isNotEmpty && campaigns.isNotEmpty) {
        for (final storageBannerId in storageBannerIds) {
          for (final campaign in campaigns) {
            if (storageBannerId == campaign.campaignId) {
              _bannersForRemove.add(campaign);
            }
          }
        }
      }

      if (_bannersForRemove.isNotEmpty) {
        for (final banner in _bannersForRemove) {
          campaigns.removeWhere(
            (CampaignModel element) => element.campaignId == banner.campaignId,
          );
        }
        return campaigns;
      } else {
        return campaigns;
      }
    } catch (e) {
      _logger.log(stateFlow, '_filteredBanners', e);
    }
    return campaigns;
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
}
