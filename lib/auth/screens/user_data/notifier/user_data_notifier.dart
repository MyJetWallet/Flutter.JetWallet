import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/kyc_profile/model/apply_user_data_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../router/notifier/startup_notifier/startup_notipod.dart';

import '../../../../shared/helpers/date_helper.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../register/notifier/referral_code_link_notipod.dart';
import '../../single_sign_in/sing_in.dart';
import '../components/birth_date/notifier/selected_date_notipod.dart';
import '../components/country/notifier/kyc_profile_countries_notipod.dart';
import 'user_data_state.dart';

class UserDataNotifier extends StateNotifier<UserDataState> {
  UserDataNotifier(this.read)
      : super(
          const UserDataState(),
        ) {
    _context = read(sNavigatorKeyPod).currentContext!;
  }

  final Reader read;
  static final _logger = Logger('AuthModelNotifier');
  late BuildContext _context;

  RegExp nameRegEx = RegExp('^[A-Za-z]{1,}\$');

  void updateFirstName(String name) {
    _logger.log(notifier, 'updateFirstName');
    state = state.copyWith(
      firstName: name,
      firstNameError: StandardFieldErrorNotifier()..enableError(),
    );
    if (nameRegEx.hasMatch(state.firstName)||state.firstName.isEmpty) {
      state.firstNameError?.disableError();
    } else {
      state.firstNameError?.enableError();
    }
    updateButtonActivity();
  }

  void updateLastName(String name) {
    _logger.log(notifier, 'updateLastName');

    state = state.copyWith(
      lastName: name,
      lastNameError: StandardFieldErrorNotifier()..enableError(),
    );
    if (nameRegEx.hasMatch(state.lastName)||state.lastName.isEmpty) {
      state.lastNameError!.disableError();
    } else {
      state.lastNameError!.enableError();
    }
    updateButtonActivity();
  }

  void updateBirthDate(String date) {
    _logger.log(notifier, 'updateDate');

    state = state.copyWith(birthDate: date);
    updateButtonActivity();
  }

  void updateButtonActivity() {
    _logger.log(notifier, '_updateButtonActivity');
    final birthDateInfo = read(selectedDateNotipod);
    final countryInfo = read(kycProfileCountriesNotipod);

    if ((countryInfo.activeCountry?.countryName.isNotEmpty ?? false) &&
        birthDateInfo.selectedDate.isNotEmpty &&
        nameRegEx.hasMatch(state.firstName) &&
        nameRegEx.hasMatch(state.lastName)) {
      state = state.copyWith(activeButton: true);
    } else {
      state = state.copyWith(activeButton: false);
    }
  }

  Future<void> saveUserData(ValueNotifier<StackLoaderNotifier> loader) async {
    _logger.log(notifier, 'saveUserData');
    final birthDateInfo = read(selectedDateNotipod);
    final countryInfo = read(kycProfileCountriesNotipod);
    final referralCodeLink = read(referralCodeLinkNotipod);
    final notificationN = read(sNotificationNotipod.notifier);
    final intl = read(intlPod);

    if (countryInfo.activeCountry!.isBlocked) {
      notificationN.showError(
        intl.user_data_bottom_sheet_country,
        id: 1,
      );
      return;
    }
    final service = read(kycProfileServicePod);
    final model = ApplyUseDataRequestModel(
      countyOfResidence: countryInfo.activeCountry!.countryCode,
      dateOfBirth: formatDateForBackEnd(birthDateInfo.selectedDate),
      firstName: state.firstName,
      lastName: state.lastName,
      referralCode: referralCodeLink.referralCode ?? '',
    );
    loader.value.startLoadingImmediately();
    try {
      await service.applyUsedData(model, intl.localeName);
      read(startupNotipod.notifier).authenticatedBoot();
    } on ServerRejectException catch (error) {
      notificationN.showError(
        error.cause,
        id: 1,
      );
      await SingIn.push(context: _context);

    } catch (error) {
      if (!mounted) return;
      _logger.log(stateFlow, 'saveUserData', error);
    }
    loader.value.finishLoading();
  }
}
