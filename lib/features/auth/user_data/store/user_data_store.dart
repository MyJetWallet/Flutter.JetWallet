// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/features/auth/register/store/referral_code_store.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/birth_date/store/selected_date_store.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/store/kyc_profile_countries_store.dart';
import 'package:jetwallet/features/auth/verification_reg/store/verification_store.dart';
import 'package:jetwallet/utils/helpers/date_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc_profile/apply_user_data_request_model.dart';

part 'user_data_store.g.dart';

class UserDataStore extends _UserDataStoreBase with _$UserDataStore {
  UserDataStore(super.birthDateInfo);

  static UserDataStore of(BuildContext context) => Provider.of<UserDataStore>(context, listen: false);
}

abstract class _UserDataStoreBase with Store {
  _UserDataStoreBase(this.birthDateInfo);

  static final _logger = Logger('AuthModelStore');

  RegExp nameRegEx = RegExp('^[A-Za-z]{1,}\$');

  @observable
  String firstName = '';

  @observable
  bool firstNameError = false;

  @observable
  String lastName = '';

  @observable
  bool lastNameError = false;

  @observable
  String birthDate = '';

  @observable
  bool birthDateError = false;

  @observable
  String country = '';

  @observable
  String promoCode = '';

  @observable
  bool activeButton = false;

  late SelectedDateStore? birthDateInfo;

  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  @action
  void clearNameError() {
    firstNameError = false;
  }

  @action
  void updateFirstName(String name) {
    _logger.log(notifier, 'updateFirstName');

    firstName = name;
    firstNameError = true;

    firstNameError = nameRegEx.hasMatch(firstName) || firstName.isEmpty ? false : true;
    updateButtonActivity();
  }

  @action
  void updateLastName(String name) {
    _logger.log(notifier, 'updateLastName');

    lastName = name;
    lastNameError = true;

    lastNameError = nameRegEx.hasMatch(lastName) || lastName.isEmpty ? false : true;
    updateButtonActivity();
  }

  @action
  void updateBirthDate(String date) {
    _logger.log(notifier, 'updateDate');

    birthDate = date;
    updateButtonActivity();
  }

  @action
  void updateButtonActivity() {
    _logger.log(notifier, '_updateButtonActivity');

    final countryInfo = getIt.get<KycProfileCountriesStore>();

    activeButton = (countryInfo.activeCountry?.countryName.isNotEmpty ?? false) &&
            birthDateInfo!.selectedDate.isNotEmpty &&
            nameRegEx.hasMatch(firstName) &&
            nameRegEx.hasMatch(lastName)
        ? true
        : false;
  }

  @action
  Future<void> saveUserData(
    StackLoaderStore loader,
    SelectedDateStore selectDate,
  ) async {
    _logger.log(notifier, 'saveUserData');

    final countryInfo = getIt.get<KycProfileCountriesStore>();
    final referralCodeLink = getIt.get<ReferallCodeStore>();

    if (countryInfo.activeCountry!.isBlocked) {
      sNotification.showError(
        intl.user_data_bottom_sheet_country,
        id: 1,
      );

      sAnalytics.signInFlowErrorCountryBlocked(
        erroCode: intl.user_data_bottom_sheet_country,
      );

      return;
    }

    final model = ApplyUseDataRequestModel(
      countyOfResidence: countryInfo.activeCountry!.countryCode,
      dateOfBirth: formatDateForBackEnd(birthDateInfo!.selectedDate),
      firstName: firstName,
      lastName: lastName,
      referralCode: referralCodeLink.referralCode ?? '',
    );

    _logger.log(notifier, model);

    loader.startLoadingImmediately();

    sAnalytics.signInFlowPersonalScreenViewLoading();

    try {
      final resp = await sNetwork.getAuthModule().postApplyUsedData(model);

      if (resp.hasError) {
        sNotification.showError(
          resp.error?.cause ?? intl.something_went_wrong,
          id: 1,
        );

        await sRouter.push(
          SingInRouter(),
        );

        return;
      }

      getIt.get<VerificationStore>().personalDetailDone();

      await getIt.get<StartupService>().secondAction();
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
      );

      await sRouter.push(
        SingInRouter(),
      );
    } catch (error) {
      _logger.log(stateFlow, 'saveUserData', error);

      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );
    }

    loader.finishLoading();
  }

  @action
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
  }
}
