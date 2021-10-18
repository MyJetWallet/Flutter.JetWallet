import 'package:contacts_service/contacts_service.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_input_phone_number_state.freezed.dart';

@freezed
class SendInputPhoneNumberState with _$SendInputPhoneNumberState {
  const factory SendInputPhoneNumberState({
    String? name,
    @Default(false) bool valid,
    @Default('') String phoneNumber,
    @Default('') String searchString,
    @Default([]) List<Contact> contacts,
  }) = _SendInputPhoneNumberState;

  const SendInputPhoneNumberState._();

  List<Contact> filteredContacts() {
    return contacts
        .where(
          (contact) =>
              contact.displayName!.toLowerCase().contains(
                    searchString.toLowerCase(),
                  ) ||
              contact.phones!.first.value!.contains(searchString),
        )
        .toList();
  }
}
