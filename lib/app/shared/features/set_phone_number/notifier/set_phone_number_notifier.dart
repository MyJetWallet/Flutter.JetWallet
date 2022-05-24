import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/phone_verification/model/phone_verification/phone_verification_request_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../shared/helpers/decompose_phone_number.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/country_code_by_user_register.dart';
import 'set_phone_number_state.dart';

class SetPhoneNumberNotifier extends StateNotifier<SetPhoneNumberState> {
  SetPhoneNumberNotifier(this.read)
      : super(
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
    _registerCountryUser();
  }

  final Reader read;

  static final _logger = Logger('SetPhoneNumberNotifier');

  Future<void> sendCode({required void Function() then}) async {
    _logger.log(notifier, 'sendCode');

    state.loader!.startLoading();

    try {
      final number = await decomposePhoneNumber(
        state.phoneNumber,
      );

      final model = PhoneVerificationRequestModel(
        locale: read(intlPod).localeName,
        phoneBody: number.body,
        phoneCode: '+${number.dialCode}',
        phoneIso: number.isoCode,
      );

      await read(phoneVerificationServicePod).request(model);

      sAnalytics.kycPhoneConfirmed();
      sAnalytics.kycChangePhoneNumber();
      if (!mounted) return;
      then();
    } on ServerRejectException catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      read(sNotificationNotipod.notifier).showError(e.cause, id: 1);
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      final intl = read(intlPod);

      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong,
        id: 1,
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
    state = state.copyWith(activeDialCode: code);
  }

  void _registerCountryUser() {
    final phoneNumber = countryCodeByUserRegister(read);

    if (phoneNumber != null) {
      state = state.copyWith(
        activeDialCode: phoneNumber,
        dialCodeController: TextEditingController(
          text: phoneNumber.countryCode,
        ),
      );
    }
  }

  void updatePhoneNumber(String phoneNumber) {
    final number = _parsePhoneNumber(phoneNumber);
    final currentOffset = state.phoneNumberController.selection.base.offset;
    state.phoneNumberController.text = number;
    state.phoneNumberController.selection =
        TextSelection.fromPosition(TextPosition(offset: currentOffset));
  }

  String _parsePhoneNumber(String phoneNumber) {
    if (phoneNumber.isNotEmpty) {
      var body = _formatPhoneNumber(phoneNumber);
      final dialCode = _formatPhoneNumber(state.dialCodeController.text);

      if (phoneNumber.length >= dialCode.length) {
        final codeFromBody = body.substring(0, dialCode.length);

        if (codeFromBody == dialCode) {
          body = body.substring(dialCode.length);
        }
      }

      if (dialCode == '380') {
        if (body.isNotEmpty && body[0] == '0') {
          body = body.substring(1);
        }
      }

      return body;
    } else {
      return phoneNumber;
    }
  }

  String _formatPhoneNumber(String phoneNumber) {
    return phoneNumber
        .replaceAll('+', '')
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '');
  }
}
