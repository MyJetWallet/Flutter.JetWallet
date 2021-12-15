import 'package:contacts_service/contacts_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../helpers/is_phone_number_valid.dart';
import '../../model/contact_model.dart';
import '../send_by_phone_permission_notifier/send_by_phone_permission_notipod.dart';
import 'send_by_phone_input_state.dart';

class SendByPhoneInputNotifier extends StateNotifier<SendByPhoneInputState> {
  SendByPhoneInputNotifier(this.read) : super(const SendByPhoneInputState()) {
    _initState();
  }

  final Reader read;

  // ignore: unused_field
  static final _logger = Logger('SendByPhoneInputNotifier');

  Future<void> _initState() async {
    final permission = read(sendByPhonePermissionNotipod);

    if (permission.permissionStatus == PermissionStatus.granted) {
      final contacts = await ContactsService.getContacts();

      final parsedContacts = <ContactModel>[];

      for (final contact in contacts) {
        if (contact.phones != null) {
          if (contact.phones!.isNotEmpty) {
            for (final phoneNumber in contact.phones!) {
              if (phoneNumber.value != null) {
                if (await isPhoneNumberValid(phoneNumber.value!)) {
                  parsedContacts.add(
                    ContactModel(
                      name: contact.displayName ?? phoneNumber.value!,
                      phoneNumber: phoneNumber.value!,
                    ),
                  );
                }
              }
            }
          }
        }
      }

      state = state.copyWith(contacts: parsedContacts);
    }
  }
}
