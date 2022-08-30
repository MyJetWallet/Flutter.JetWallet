import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/send_by_phone/model/contact_model.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_permission_store.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_kit/simple_kit.dart';
part 'send_by_phone_input_store.g.dart';

class SendByPhoneInputStore extends _SendByPhoneInputStoreBase
    with _$SendByPhoneInputStore {
  SendByPhoneInputStore() : super();
}

abstract class _SendByPhoneInputStoreBase with Store {
  _SendByPhoneInputStoreBase() {
    _initState();
  }

  SendByPhonePermission permission = SendByPhonePermission();

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

  @computed
  bool get isReadyToContinue {
    return dialCodeController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty;
  }

  @action
  Future<void> _initState() async {
    if (permission.permissionStatus == PermissionStatus.granted) {
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

    final number = '${code.countryCode} ${phoneNumberController.text}';
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
    _logger.log(notifier, 'updateSearch');

    phoneSearch = _phoneSearch;

    _filterByPhoneSearchInput();
  }

  @action
  Future<void> _filterByPhoneSearchInput() async {
    final newList = List<ContactModel>.from(contacts);

    newList.removeWhere((element) {
      return !_isContactInSearch(element);
    });

    if (newList.isEmpty && validWeakPhoneNumber(phoneSearch)) {
      final dialCode = dialCodeController.text;
      final number = phoneSearch;

      var phoneNumber = '';

      phoneNumber = number.startsWith('+') ? number : '$dialCode $number';

      newList.add(
        ContactModel(
          name: number,
          phoneNumber: phoneNumber,
          isCustomContact: true,
          valid: await isInternationalPhoneNumberValid(phoneNumber),
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
      );

      final phoneNumber = PhoneNumber(
        phoneNumber: info.phoneNumber,
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
        dialCodeController.text = '+${info.dialCode!}';
        phoneNumberController.text = parsable;

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
  void updateContactName(ContactModel contact) {
    pickedContact = contact;
  }

  @action
  void updateActiveDialCode(SPhoneNumber? number) {
    activeDialCode = number;
  }
}
