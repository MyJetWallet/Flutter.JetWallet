import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/helpers/country_code_by_user_register.dart';
import 'package:jetwallet/utils/helpers/decompose_phone_number.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logger/logger.dart';
import 'package:logging/logging.dart' as logging;
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification/phone_verification_request_model.dart';

import '../../../core/di/di.dart';
import '../../../core/services/logger_service/logger_service.dart';
part 'set_phone_number_store.g.dart';

@lazySingleton
class SetPhoneNumberStore = _SetPhoneNumberStoreBase with _$SetPhoneNumberStore;

abstract class _SetPhoneNumberStoreBase with Store {
  _SetPhoneNumberStoreBase() {
    activeDialCode = sPhoneNumbers[0];
    dialCodeController = TextEditingController(
      text: sPhoneNumbers[0].countryCode,
    );

    loader = StackLoaderStore();
    phoneFieldError = StandardFieldErrorNotifier();

    _registerCountryUser();

    phoneNumberController.addListener(phoneControllerListener);
  }

  static final _logger = logging.Logger('SetPhoneNumberStore');

  @observable
  SPhoneNumber? activeDialCode;

  @observable
  StackLoaderStore? loader;

  @observable
  StandardFieldErrorNotifier? phoneFieldError;

  @observable
  String dialCodeSearch = '';

  @observable
  String phoneInput = '';

  @observable
  String pin = '';

  @observable
  bool isButtonActive = false;

  @observable
  bool canCLick = true;

  @observable
  ObservableList<SPhoneNumber> sortedDialCodes = ObservableList.of([]);

  late TextEditingController dialCodeController;

  TextEditingController phoneNumberController = TextEditingController();

  String phoneNumber() =>
      '${dialCodeController.text}${phoneNumberController.text}';

  @computed
  bool get isReadyToContinue {
    final condition1 = dialCodeController.text.isNotEmpty;
    final condition2 = phoneNumberController.text.isNotEmpty;
    final condition3 = validWeakPhoneNumber(phoneNumber());

    return condition1 && condition2 && condition3;
  }

  @action
  void phoneControllerListener() {
    isButtonActive = dialCodeController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        validWeakPhoneNumber(phoneNumber());
  }

  @action
  void updatePin(String value) {
    pin = value;
  }

  @action
  Future<void> sendCode({required void Function() then}) async {
    getIt.get<SimpleLoggerService>().log(
      level: Level.info,
      place: 'sendCode',
      message: 'sendCode start',
    );
    _logger.log(notifier, 'sendCode');

    loader!.startLoading();

    try {
      final number = await decomposePhoneNumber(
        phoneNumber(),
        isoCodeNumber: activeDialCode?.isoCode ?? '',
      );

      final model = PhoneVerificationRequestModel(
        locale: intl.localeName,
        phoneBody: number.body.replaceAll(
          activeDialCode?.countryCode ?? dialCodeController.text,
          '',
        ),
        phoneCode: activeDialCode?.countryCode ?? dialCodeController.text,
        phoneIso: number.isoCode,
        verificationType: 1,
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        pin: pin,
      );

      final resp = await sNetwork
          .getValidationModule()
          .postPhoneVerificationRequest(model);

      if (resp.hasError) {
        _logger.log(stateFlow, 'sendCode', resp.error);
        sNotification.showError(resp.error?.cause ?? '', id: 1);
        await sRouter.pop();

        return;
      }

      sAnalytics.kycPhoneConfirmed();
      sAnalytics.kycChangePhoneNumber();

      then();
    } on ServerRejectException catch (e) {
      _logger.log(stateFlow, 'sendCode', e);
      getIt.get<SimpleLoggerService>().log(
        level: Level.info,
        place: 'sendCode',
        message: '$e',
      );
      await sRouter.pop();

      sNotification.showError(e.cause, id: 1);
    } catch (e) {
      await sRouter.pop();

      _logger.log(stateFlow, 'sendCode', e);
      getIt.get<SimpleLoggerService>().log(
        level: Level.info,
        place: 'sendCode',
        message: '$e',
      );

      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );
    } finally {
      loader!.finishLoading();
    }
  }

  @action
  void initDialCodeSearch() {
    updateDialCodeSearch('');
  }

  @action
  void updateDialCodeSearch(String _dialCodeSearch) {
    _logger.log(notifier, 'updateDialCodeSearch');

    dialCodeSearch = _dialCodeSearch;

    _filterByDialCodeSearch();
  }

  @action
  void _filterByDialCodeSearch() {
    final newList = List<SPhoneNumber>.from(sPhoneNumbers);

    newList.removeWhere((element) {
      return !_isDialCodeInSearch(element);
    });

    sortedDialCodes = ObservableList.of(newList);
  }

  @action
  bool _isDialCodeInSearch(SPhoneNumber number) {
    final search = dialCodeSearch.toLowerCase().replaceAll(' ', '');
    final code = number.countryCode.toLowerCase().replaceAll(' ', '');
    final name = number.countryName.toLowerCase().replaceAll(' ', '');

    return code.contains(search) || name.contains(search);
  }

  @action
  void pickDialCodeFromSearch(SPhoneNumber code) {
    dialCodeController.text = code.countryCode;
    updateActiveDialCode(code);
  }

  @action
  void updateActiveDialCode(SPhoneNumber code) {
    activeDialCode = code;
  }

  @action
  void _registerCountryUser() {
    final phoneNumber = countryCodeByUserRegister();

    if (phoneNumber != null) {
      activeDialCode = phoneNumber;
      dialCodeController = TextEditingController(
        text: phoneNumber.countryCode,
      );
    }
  }

  @action
  void updatePhoneNumber(String phoneNumber) {
    final checkStartNumber = _parsePhoneNumber(phoneNumber);
    if (
      !validWeakPhoneNumber(checkStartNumber) &&
      phoneNumber.isNotEmpty &&
      phoneNumber != '+'
    ) {
      phoneNumberController.text = phoneInput;

      return;
    }
    var finalPhone = phoneNumber;
    var mustToSubstring = false;
    var charsToSubstring = 0;
    if (phoneNumber.length > 1 && phoneInput.isEmpty) {
      final dialString = dialCodeController.text;
      for (var char = 0; char <= dialString.length; char++) {
        final dialStringCheck = dialString.substring(char);
        final phoneSearchShort = finalPhone.substring(0, dialStringCheck.length);
        if (dialStringCheck == phoneSearchShort) {
          mustToSubstring = true;
          if (charsToSubstring < dialStringCheck.length) {
            charsToSubstring = dialStringCheck.length;
          }
        }
      }
    }

    if (mustToSubstring) {
      finalPhone = finalPhone.substring(charsToSubstring);
      final number = _parsePhoneNumber(finalPhone);
      phoneInput = number;
      phoneNumberController.text = number;
      print(number.length);
      print(phoneNumberController.selection.base.offset);
      phoneNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: number.length,
        ),
      );
    } else {
      final number = _parsePhoneNumber(finalPhone);
      phoneInput = number;
      final currentOffset = phoneNumberController.selection.base.offset;
      phoneNumberController.text = number;
      phoneNumberController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: currentOffset,
        ),
      );
    }
  }

  @action
  String _parsePhoneNumber(String phoneNumber) {
    return phoneNumber.isNotEmpty
        ? _formatPhoneNumber(phoneNumber)
        : phoneNumber;
  }

  @action
  String _formatPhoneNumber(String phoneNumber) {
    return phoneNumber
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '');
  }

  @action
  Future<void> pasteCode() async {
    _logger.log(notifier, 'pastePhone');

    final data = await Clipboard.getData('text/plain');
    final phonePasted = data?.text?.trim() ?? '';
    if (phonePasted.isNotEmpty) {
      updatePhoneNumber(phonePasted);
    }
  }

  @action
  void toggleClick(bool value) {
    canCLick = value;
  }

  @action
  Future<void> clearPhone() async {
    _logger.log(notifier, 'clearPhone');

    phoneNumberController.text = '';
    phoneInput = '';
  }
}
