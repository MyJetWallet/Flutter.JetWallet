import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/campaign_response_model.dart';

part 'reward_campaign_store.g.dart';

class RewardCampaignStore extends _RewardCampaignStoreBase with _$RewardCampaignStore {
  RewardCampaignStore(super.isFilterEnabled);

  static _RewardCampaignStoreBase of(BuildContext context) => Provider.of<RewardCampaignStore>(context, listen: false);
}

abstract class _RewardCampaignStoreBase with Store {
  _RewardCampaignStoreBase(this.isFilterEnabled) {
    if (sSignalRModules.marketCampaigns.isNotEmpty) {
      updateCampaigns(sSignalRModules.marketCampaigns);
    } else {
      Future.delayed(
        const Duration(seconds: 5),
        () {
          updateCampaigns(sSignalRModules.marketCampaigns);
        },
      );
    }
  }

  static final _logger = Logger('CampaignStore');

  @observable
  bool isFilterEnabled = false;

  @observable
  ObservableList<CampaignModel> campaigns = ObservableList.of([]);

  LocalStorageService storage = sLocalStorageService;

  @action
  Future<void> updateCampaigns(List<CampaignModel> newCampaigns) async {
    _logger.log(notifier, 'updateCampaigns');

    final validCampaigns = <CampaignModel>[
      if (isFilterEnabled) ...await _filteredBanners(newCampaigns) else ...newCampaigns,
    ];

    campaigns = ObservableList.of(validCampaigns);
  }

  @action
  Future<void> deleteCampaign(CampaignModel newCampaign) async {
    _logger.log(notifier, 'deleteCampaign');

    try {
      final newList = List<CampaignModel>.from(campaigns);

      newList.remove(newCampaign);

      await _setBannersIdsToStorage(newCampaign.campaignId);

      campaigns = ObservableList.of(newList);
    } catch (e) {
      _logger.log(stateFlow, 'deleteCampaign', e);
    }
  }

  @action
  Future<List<CampaignModel>> _filteredBanners(
    List<CampaignModel> newCampaigns,
  ) async {
    final bannersForRemove = <CampaignModel>[];

    try {
      final storageBannerIds = await _getBannersIdsFromStorage();
      if (storageBannerIds.isNotEmpty && newCampaigns.isNotEmpty) {
        for (final storageBannerId in storageBannerIds) {
          for (final campaign in newCampaigns) {
            if (storageBannerId == campaign.campaignId) {
              bannersForRemove.add(campaign);
            }
          }
        }
      }

      if (bannersForRemove.isNotEmpty) {
        for (final banner in bannersForRemove) {
          newCampaigns.removeWhere(
            (CampaignModel element) => element.campaignId == banner.campaignId,
          );
        }
      }
    } catch (e) {
      _logger.log(stateFlow, '_filteredBanners', e);
    }

    return newCampaigns;
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
