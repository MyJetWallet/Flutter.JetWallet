import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/phone_verification/model/phone_verification/phone_verification_request_model.dart';
import '../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/country_code_by_user_register.dart';
import 'set_phone_number_state.dart';

class SetPhoneNumberNotifier extends StateNotifier<SetPhoneNumberState> {
  SetPhoneNumberNotifier(this.read) : super(
    SetPhoneNumberState(
      activeDialCode: sPhoneNumbers[0],
      dialCodeController: TextEditingController(
        text: sPhoneNumbers[0].countryCode,
      ),
      phoneNumberController: TextEditingController(),
      loader: StackLoaderNotifier(),
      phoneFieldError: StandardFieldErrorNotifier(),
    ),
  ) {
    _checkRegisterCountryUser();
  }

  final Reader read;

  static final _logger = Logger('SetPhoneNumberNotifier');

  Future<void> sendCode({required void Function() then}) async {
    _logger.log(notifier, 'sendCode');

    state.loader!.startLoading();

    try {
      final model = PhoneVerificationRequestModel(
        language: read(intlPod).localeName,
        phoneNumber: state.phoneNumber,
      );

      await read(phoneVerificationServicePod).request(model);

      if (!mounted) return;
      then();
    } on ServerRejectException catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      sShowErrorNotification(
        read(sNotificationQueueNotipod.notifier),
        e.cause,
      );
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      sShowErrorNotification(
        read(sNotificationQueueNotipod.notifier),
        'Something went wrong',
      );
    } finally {
      state.loader!.finishLoading();
    }
  }

  void initDialCodeSearch() {
    updateDialCodeSearch('');
  }

  void updateDialCodeSearch(String dialCodeSearch) {
    _logger.log(notifier, 'updateDialCodeSearch');

    state = state.copyWith(dialCodeSearch: dialCodeSearch);

    _filterByDialCodeSearch();
  }

  void _checkRegisterCountryUser() {
    final userInfo = read(userInfoNotipod);

    if (userInfo.countryOfRegistration.isNotEmpty) {
      final phoneNumber = countryCodeByUserRegister(
        userInfo.countryOfRegistration,
      );

      if (phoneNumber != null) {
        state = state.copyWith(
          activeDialCode: phoneNumber,
          dialCodeController: TextEditingController(
            text: phoneNumber.countryCode,
          ),
        );
      }
    }
  }

  void _filterByDialCodeSearch() {
    final newList = List<SPhoneNumber>.from(sPhoneNumbers);

    newList.removeWhere((element) {
      return !_isDialCodeInSearch(element);
    });

    state = state.copyWith(sortedDialCodes: List.from(newList));
  }

  bool _isDialCodeInSearch(SPhoneNumber number) {
    final search = state.dialCodeSearch.toLowerCase().replaceAll(' ', '');
    final code = number.countryCode.toLowerCase().replaceAll(' ', '');
    final name = number.countryName.toLowerCase().replaceAll(' ', '');

    return code.contains(search) || name.contains(search);
  }

  void pickDialCodeFromSearch(SPhoneNumber code) {
    state.dialCodeController.text = code.countryCode;
    updateActiveDialCode(code);
  }

  void updateActiveDialCode(SPhoneNumber code) {
    state = state.copyWith(
      activeDialCode: code,
    );
  }
}
