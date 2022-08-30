import 'dart:convert';

import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/signal_r/models/campaign_response_model.dart';

part 'reward_campaign_store.g.dart';

class RewardCampaignStore extends _RewardCampaignStoreBase
    with _$RewardCampaignStore {
  RewardCampaignStore(bool isFilterEnabled) : super(isFilterEnabled);
}

abstract class _RewardCampaignStoreBase with Store {
  _RewardCampaignStoreBase(this.isFilterEnabled) {
    updateCampaigns(campaigns);
  }

  static final _logger = Logger('CampaignStore');

  @observable
  bool isFilterEnabled = false;

  @observable
  ObservableList<CampaignModel> campaigns = ObservableList.of([]);

  LocalStorageService storage = sLocalStorageService;

  @action
  Future<void> updateCampaigns(List<CampaignModel> _campaigns) async {
    _logger.log(notifier, 'updateCampaigns');

    final validCampaigns = <CampaignModel>[
      if (isFilterEnabled)
        ...await _filteredBanners(_campaigns)
      else
        ..._campaigns,
    ];

    campaigns = ObservableList.of(validCampaigns);
  }

  @action
  Future<void> deleteCampaign(CampaignModel _campaign) async {
    _logger.log(notifier, 'deleteCampaign');

    try {
      final newList = List<CampaignModel>.from(campaigns);

      newList.remove(_campaign);

      await _setBannersIdsToStorage(_campaign.campaignId);

      campaigns = ObservableList.of(newList);
    } catch (e) {
      _logger.log(stateFlow, 'deleteCampaign', e);
    }
  }

  @action
  Future<List<CampaignModel>> _filteredBanners(
    List<CampaignModel> _campaigns,
  ) async {
    final bannersForRemove = <CampaignModel>[];

    try {
      final storageBannerIds = await _getBannersIdsFromStorage();
      if (storageBannerIds.isNotEmpty && _campaigns.isNotEmpty) {
        for (final storageBannerId in storageBannerIds) {
          for (final campaign in _campaigns) {
            if (storageBannerId == campaign.campaignId) {
              bannersForRemove.add(campaign);
            }
          }
        }
      }

      if (bannersForRemove.isNotEmpty) {
        for (final banner in bannersForRemove) {
          _campaigns.removeWhere(
            (CampaignModel element) => element.campaignId == banner.campaignId,
          );
        }
      }
    } catch (e) {
      _logger.log(stateFlow, '_filteredBanners', e);
    }

    return _campaigns;
  }

  @action
  Future<void> _setBannersIdsToStorage(String bannerId) async {
    try {
      final bannersIds = await _getBannersIdsFromStorage();

      if (bannersIds.isNotEmpty) {
        await storage.setList(bannersIdsKey, [...bannersIds, bannerId]);
      } else {
        await storage.setList(bannersIdsKey, [bannerId]);
      }
    } catch (e) {
      _logger.log(stateFlow, '_setBannersIdsToStorage', e);
    }
  }

  @action
  Future<List<String>> _getBannersIdsFromStorage() async {
    try {
      final bannersIds = await storage.getValue(bannersIdsKey);
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
