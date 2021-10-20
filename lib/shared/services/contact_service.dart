import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactService {
  Future<void> askPermission({
    required void Function() onGranted,
    required void Function() onDenied,
  }) async {
    final permissionStatus = await _getContactPermission();

    if (permissionStatus == PermissionStatus.granted) {
      onGranted();
    } else {
      onDenied();
    }
  }

  Future<List<Contact>> contactsWithPhoneNumber() async {
    final contacts = await ContactsService.getContacts();

    return contacts
        .where(
          (contact) => contact.phones != null && contact.phones!.isNotEmpty,
        )
        .toList();
  }

  Future<PermissionStatus> _getContactPermission() async {
    final permissionStatus = await Permission.contacts.request();

    return permissionStatus;
  }
}
