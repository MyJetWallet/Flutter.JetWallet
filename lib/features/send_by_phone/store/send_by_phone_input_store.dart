import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/send_by_phone/model/contact_model.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_permission_store.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../utils/helpers/country_code_by_user_register.dart';
part 'send_by_phone_input_store.g.dart';

@lazySingleton
class SendByPhoneInputStore extends _SendByPhoneInputStoreBase
    with _$SendByPhoneInputStore {
  SendByPhoneInputStore() : super();

  static _SendByPhoneInputStoreBase of(BuildContext context) =>
      Provider.of<SendByPhoneInputStore>(context, listen: false);
}

abstract class _SendByPhoneInputStoreBase with Store {
  _SendByPhoneInputStoreBase() {
    initState(SendByPhonePermission());

    dialCodeController.addListener(controllersListener);
    phoneNumberController.addListener(controllersListener);

    dialCodeController.text = sPhoneNumbers[0].countryCode;
    searchTextController = TextEditingController(text: phoneSearch);
    _registerCountryUser();
  }

  SendByPhonePermission? permission;

  static final _logger = Logger('SendByPhoneInputStore');

  @observable
  SPhoneNumber? activeDialCode;

  @observable
  ContactModel? pickedContact;

  @observable
  bool contactWithoutCode = false;

  @observable
  String dialCodeSearch = '';

  @observable
  ObservableList<SPhoneNumber> sortedDialCodes = ObservableList.of([]);

  @observable
  String phoneSearch = '';

  @observable
  ObservableList<ContactModel> contacts = ObservableList.of([]);

  @observable
  ObservableList<ContactModel> sortedContacts = ObservableList.of([]);

  @observable
  TextEditingController dialCodeController = TextEditingController();

  @observable
  TextEditingController phoneNumberController = TextEditingController();

  late TextEditingController searchTextController;

  @observable
  bool isReadyToContinue = false;

  @action
  void controllersListener() {
    isReadyToContinue = dialCodeController.text.isNotEmpty &&
            phoneNumberController.text.isNotEmpty
        ? true
        : false;
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
  void clear() {
    dialCodeController.text = '';
    phoneNumberController.text = '';
    searchTextController.text = '';
  }

  @action
  Future<void> initState(SendByPhonePermission contactStore) async {
    permission = contactStore;

    if (permission!.permissionStatus == PermissionStatus.granted) {
      final _contacts =
          await ContactsService.getContacts(withThumbnails: false);

      final parsedContacts = <ContactModel>{};
      for (final contact in _contacts) {
        if (contact.phones!.isNotEmpty) {
          for (final phoneNumber in contact.phones!) {
            if (phoneNumber.value != null) {
              parsedContacts.add(
                ContactModel(
                  name: contact.displayName ?? phoneNumber.value!,
                  phoneNumber: phoneNumber.value!.replaceAll(' ', ''),
                ),
              );
            }
          }
        }
      }
      final result = parsedContacts.toList();

      contacts = ObservableList.of(result);
      sortedContacts = ObservableList.of(result);
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

    final number = '${code.countryCode} ${phoneNumberController.text.replaceAll(
      activeDialCode?.countryCode ?? dialCodeController.text,
      '',
    )}';
    updateContactName(
      ContactModel(
        name: number,
        phoneNumber: number,
      ),
    );
  }

  @action
  void initPhoneSearch() {
    _logger.log(notifier, 'initPhoneSearch');

    final dialCode = dialCodeController.text;
    final phoneNumber = phoneNumberController.text;

    if (dialCode.isEmpty || dialCode == intl.sendByPhoneInput_select) {
      updatePhoneSearch(phoneNumber);
    } else if (phoneNumber.isEmpty) {
      updatePhoneSearch('');
    } else {
      updatePhoneSearch('$dialCode $phoneNumber');
    }
  }

  @action
  void updatePhoneSearch(String _phoneSearch) {
    final checkStartNumber = _parsePhoneNumber(_phoneSearch);
    // if (
    //   !validWeakPhoneNumber(checkStartNumber) &&
    //   _phoneSearch.isNotEmpty &&
    //   _phoneSearch != '+'
    // ) {
    //   searchTextController.text = phoneSearch;
    //   _filterByPhoneSearchInput();
    //
    //   return;
    // }
    _logger.log(notifier, 'updateSearch');
    var finalPhone = _phoneSearch;
    var mustToSubstring = false;
    var charsToSubstring = 0;
    if (_phoneSearch.length > 1 && phoneSearch.isEmpty) {
      final dialString = dialCodeController.text;
      for (var char = 0; char <= dialString.length; char++) {
        final dialStringCheck = dialString.substring(char);
        final phoneSearchShort =
            finalPhone.substring(0, dialStringCheck.length);
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
      searchTextController.text = finalPhone;
      final number = _parsePhoneNumber(finalPhone);
      phoneSearch = number;
      searchTextController.text = number;

      searchTextController.selection = TextSelection.fromPosition(
        TextPosition(
          offset: number.length,
        ),
      );
    } else {
      if (finalPhone.isNotEmpty) {
        final number = _parsePhoneNumber(finalPhone);
        phoneSearch = number;
        final currentOffset = searchTextController.selection.base.offset;
        searchTextController.text = number;
        searchTextController.selection = TextSelection.fromPosition(
          TextPosition(
            offset: currentOffset,
          ),
        );
      } else {
        phoneSearch = '';
        searchTextController.text = '';
      }
    }
    _filterByPhoneSearchInput();
  }

  @action
  Future<void> _filterByPhoneSearchInput() async {
    final newList = List<ContactModel>.from(contacts);

    newList.removeWhere((element) {
      return !_isContactInSearch(element);
    });

    if (validWeakPhoneNumber(phoneSearch)) {
      final dialCode = dialCodeController.text;
      final number = phoneSearch;

      var phoneNumber = '';

      phoneNumber = number.startsWith('+') ? number : '$dialCode $number';

      newList.insert(
        0,
        ContactModel(
          name: number,
          phoneNumber: phoneNumber,
          isCustomContact: true,
          valid: await isInternationalPhoneNumberValid(
            phoneNumber,
            activeDialCode?.isoCode ?? '',
          ),
        ),
      );
    }

    sortedContacts = ObservableList.of(newList);
  }

  @action
  Future<void> pickNumberFromSearch(ContactModel contact) async {
    _logger.log(notifier, 'pickNumberFromSearch');

    if (contact.phoneNumber[0] == '+') {
      final info = await PhoneNumber.getRegionInfoFromPhoneNumber(
        contact.phoneNumber,
        activeDialCode?.isoCode ?? '',
      );

      final phoneNumber = PhoneNumber(
        phoneNumber: info.phoneNumber?.replaceAll(
          activeDialCode?.countryCode ?? dialCodeController.text,
          '',
        ),
        isoCode: info.isoCode,
      );

      final parsable = await PhoneNumber.getParsableNumber(phoneNumber);

      var validNumber = false;
      var code = sPhoneNumbers[0];

      for (final sNumber in sPhoneNumbers) {
        if (sNumber.isoCode == info.isoCode) {
          validNumber = true;
          code = sNumber;
        }
      }

      if (info.dialCode != null && validNumber) {
        dialCodeController.text = code.countryCode ?? '';
        phoneNumberController.text = parsable.replaceAll(
          activeDialCode?.countryCode ?? dialCodeController.text,
          '',
        );

        updateActiveDialCode(code);
      } else {
        dialCodeController.clear();

        updateActiveDialCode(null);

        phoneNumberController.text = contact.phoneNumber.startsWith('+')
            ? contact.phoneNumber.substring(1)
            : contact.phoneNumber;
      }
    } else {
      final finalCode = contact.phoneNumber
          .replaceAll('(', ' ')
          .replaceAll(')', ' ')
          .replaceAll('-', ' ');

      phoneNumberController.text = finalCode;

      dialCodeController.text = intl.sendByPhoneInput_select;
      contactWithoutCode = true;
    }

    if (contact.isCustomContact) {
      updateContactName(
        ContactModel(
          name: contact.phoneNumber,
          phoneNumber: contact.phoneNumber,
        ),
      );
    } else {
      updateContactName(contact);
    }

    searchTextController.text = phoneNumberController.text;
  }

  @action
  bool _isContactInSearch(ContactModel contact) {
    final search = phoneSearch.toLowerCase().replaceAll(' ', '');
    final name = contact.name.toLowerCase().replaceAll(' ', '');
    final number = contact.phoneNumber.toLowerCase().replaceAll(' ', '');
    final parsedNamber = number.replaceAll('-', '');

    return name.contains(search) || parsedNamber.contains(search);
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
  void updateContactName(ContactModel contact) {
    pickedContact = contact;
  }

  @action
  void updateActiveDialCode(SPhoneNumber? number) {
    activeDialCode = number;
  }

  @action
  Future<void> pasteCode() async {
    _logger.log(notifier, 'pastePhone');

    final data = await Clipboard.getData('text/plain');
    final phonePasted = data?.text?.trim() ?? '';
    searchTextController.text = _parsePhoneNumber(phonePasted);
    if (phonePasted.isNotEmpty) {
      updatePhoneSearch(_parsePhoneNumber(phonePasted));
    }
  }
}
