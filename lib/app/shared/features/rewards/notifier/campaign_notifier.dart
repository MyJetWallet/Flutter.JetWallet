import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/signal_r/model/campaign_response_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/services/local_storage_service.dart';

class CampaignNotifier extends StateNotifier<List<CampaignModel>> {
  CampaignNotifier({
    this.isFilterEnabled = false,
    required this.read,
    required this.campaigns,
  }) : super(<CampaignModel>[]) {
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

    state = validCampaigns;
  }

  Future<void> deleteCampaign(CampaignModel campaign) async {
    _logger.log(notifier, 'deleteCampaign');

    try {
      final newList = List<CampaignModel>.from(state);
      newList.remove(campaign);
      await _setBannersIdsToStorage(campaign.campaignId);
      state = newList;
    } catch (e) {
      _logger.log(stateFlow, 'deleteCampaign', e);
    }
  }

  Future<List<CampaignModel>> _filteredBanners(
    List<CampaignModel> campaigns,
  ) async {
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
      }
    } catch (e) {
      _logger.log(stateFlow, '_filteredBanners', e);
    }
    return campaigns;
  }

  Future<void> _setBannersIdsToStorage(String bannerId) async {
    try {
      final bannersIds = await _getBannersIdsFromStorage();

      if (bannersIds.isNotEmpty) {
        await storage.setJson(bannersIdsKey, [...bannersIds, bannerId]);
      } else {
        await storage.setJson(bannersIdsKey, [bannerId]);
      }
    } catch (e) {
      _logger.log(stateFlow, '_setBannersIdsToStorage', e);
    }
  }

  Future<List<String>> _getBannersIdsFromStorage() async {
    try {
      final bannersIds = await storage.getJson(bannersIdsKey);
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
