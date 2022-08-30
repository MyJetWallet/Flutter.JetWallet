import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/helpers/country_code_by_user_register.dart';
import 'package:jetwallet/utils/helpers/decompose_phone_number.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/validation_api/models/phone_verification/phone_verification_request_model.dart';
part 'set_phone_number_store.g.dart';

@lazySingleton
class SetPhoneNumberStore = _SetPhoneNumberStoreBase with _$SetPhoneNumberStore;

abstract class _SetPhoneNumberStoreBase with Store {
  _SetPhoneNumberStoreBase() {
    activeDialCode = sPhoneNumbers[0];
    dialCodeController = TextEditingController(
      text: sPhoneNumbers[0].countryCode,
    );
    phoneNumberController = TextEditingController();
    loader = StackLoaderStore();
    phoneFieldError = StandardFieldErrorNotifier();

    _registerCountryUser();
  }

  static final _logger = Logger('SetPhoneNumberStore');

  @observable
  SPhoneNumber? activeDialCode;

  @observable
  StackLoaderStore? loader;

  @observable
  StandardFieldErrorNotifier? phoneFieldError;

  @observable
  String dialCodeSearch = '';

  @observable
  ObservableList<SPhoneNumber> sortedDialCodes = ObservableList.of([]);

  late TextEditingController dialCodeController;

  late TextEditingController phoneNumberController;

  @computed
  String get phoneNumber {
    return dialCodeController.text + phoneNumberController.text;
  }

  @computed
  bool get isReadyToContinue {
    final condition1 = dialCodeController.text.isNotEmpty;
    final condition2 = phoneNumberController.text.isNotEmpty;
    final condition3 = validWeakPhoneNumber(phoneNumber);

    return condition1 && condition2 && condition3;
  }

  @action
  Future<void> sendCode({required void Function() then}) async {
    _logger.log(notifier, 'sendCode');

    loader!.startLoading();

    try {
      final number = await decomposePhoneNumber(
        phoneNumber,
      );

      final model = PhoneVerificationRequestModel(
        locale: intl.localeName,
        phoneBody: number.body,
        phoneCode: '+${number.dialCode}',
        phoneIso: number.isoCode,
      );

      final _ = await sNetwork
          .getValidationModule()
          .postPhoneVerificationRequest(model);

      sAnalytics.kycPhoneConfirmed();
      sAnalytics.kycChangePhoneNumber();
      then();
    } on ServerRejectException catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

      sNotification.showError(e.cause, id: 1);
    } catch (e) {
      _logger.log(stateFlow, 'sendCode', e);

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
    final number = _parsePhoneNumber(phoneNumber);
    final currentOffset = phoneNumberController.selection.base.offset;
    phoneNumberController.text = number;
    phoneNumberController.selection = TextSelection.fromPosition(
      TextPosition(
        offset: currentOffset,
      ),
    );
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
        .replaceAll('+', '')
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll('-', '');
  }
}
