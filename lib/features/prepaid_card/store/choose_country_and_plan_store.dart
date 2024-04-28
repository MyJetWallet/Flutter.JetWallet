import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/utils/helpers/country_code_by_user_register.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/get_purchase_card_brands_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/purchase_card_brand_list_response_model.dart';

part 'choose_country_and_plan_store.g.dart';

class ChooseCountryAndPlanStore extends _ChooseCountryAndPlanStoreBase with _$ChooseCountryAndPlanStore {
  ChooseCountryAndPlanStore() : super();

  static _ChooseCountryAndPlanStoreBase of(BuildContext context) => Provider.of<ChooseCountryAndPlanStore>(
        context,
        listen: false,
      );
}

abstract class _ChooseCountryAndPlanStoreBase with Store {
  @action
  Future<void> init() async {
    selectedCountry = countryCodeByUserRegister() ?? sPhoneNumbers[0];
    await _getCountries();
    await _getBrands();
  }

  @observable
  late SPhoneNumber selectedCountry;

  @observable
  List<SPhoneNumber> countries = [];

  @observable
  ObservableList<PurchaseCardBrandDtoModel> brandsList = ObservableList.of([]);

  @observable
  PurchaseCardBrandDtoModel? selectedBrand;

  @action
  Future<void> _getCountries() async {
    try {
      final response = await sNetwork.getWalletModule().postCardGetCountries();

      response.pick(
        onData: (data) {
          selectedCountry = getCountryByCode(data.clientCountry);
          countries = convertToCountries(data.countries);
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
            needFeedback: true,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
        needFeedback: true,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    }
  }

  @action
  Future<void> _getBrands() async {
    try {
      final model = GetPurchaseCardBrandsRequestModel(
        country: selectedCountry.isoCode,
      );
      final response = await sNetwork.getWalletModule().postGetBrands(model);

      response.pick(
        onData: (data) {
          brandsList = ObservableList.of(data.brands);

          if (brandsList.isNotEmpty) {
            selectedBrand = brandsList.first;
          }
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
            needFeedback: true,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
        needFeedback: true,
      );
    } catch (error) {
      // it means that the user's country is not available for this service
      if (selectedCountry.isoCode == countryCodeByUserRegister()?.isoCode) return;
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    }
  }

  @action
  void setSelectedBrand(PurchaseCardBrandDtoModel newSelectedBrand) {
    selectedBrand = newSelectedBrand;
  }

  @action
  Future<void> setNewCountry(SPhoneNumber newCountry) async {
    try {
      selectedCountry = newCountry;
      getIt.get<GlobalLoader>().setLoading(true);
      await _getBrands();
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    } finally {
      getIt.get<GlobalLoader>().setLoading(false);
    }
  }

  List<SPhoneNumber> convertToCountries(List<String> countriesCodes) {
    final result = <SPhoneNumber>[];

    for (final countryCode in countriesCodes) {
      final country = sPhoneNumbers.firstWhere(
        (element) => element.isoCode == countryCode,
        orElse: () {
          return const SPhoneNumber(
            countryCode: '',
            countryName: '',
            isoCode: '',
            numCode: '',
            alphaCode: '',
          );
        },
      );
      if (country.countryName != '') {
        result.add(country);
      }
    }

    return result;
  }
}
