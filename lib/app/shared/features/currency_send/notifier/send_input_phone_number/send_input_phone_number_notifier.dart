import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/local_storage_service.dart';
import 'send_input_phone_number_state.dart';

class SendInputPhoneNumberNotifier
    extends StateNotifier<SendInputPhoneNumberState> {
  SendInputPhoneNumberNotifier(
    this.read,
  ) : super(const SendInputPhoneNumberState()) {
    storage = read(localStorageServicePod);
  }

  Reader read;
  late LocalStorageService storage;

  static final _logger = Logger('SendInputPhoneNumberNotifier');

  Future<bool> checkPermissionAsked() async {
    _logger.log(notifier, 'checkPermissionAsked');

    final contactsPermissionAsked =
        await storage.getString(contactsPermissionKey);

    return contactsPermissionAsked != null && contactsPermissionAsked == 'true';
  }

  Future<void> setPermissionAsked() async {
    _logger.log(notifier, 'setPermissionAsked');

    await storage.setString(contactsPermissionKey, 'true');
  }

  void askContactsPermission(void Function() showContactsSearchBottomSheet) {
    _logger.log(notifier, 'askContactsPermission');

    final contactsService = read(contactsServicePod);

    contactsService.askPermission(
      onGranted: () async {
        final contacts = await contactsService.contactsWithPhoneNumber();
        state = state.copyWith(contacts: contacts);

        showContactsSearchBottomSheet();
      },
      onDenied: () {
        // TODO(Vova): Add navigation to app's settings?
      },
    );
  }

  void updateSearch(String search) {
    _logger.log(notifier, 'updateSearch');

    state = state.copyWith(searchString: search);
  }

  void updateValid({required bool valid}) {
    _logger.log(notifier, 'updateValid');

    state = state.copyWith(valid: valid);
  }

  void updatePhoneNumber(String? number) {
    _logger.log(notifier, 'updatePhoneNumber');

    state = state.copyWith(phoneNumber: number ?? '');
  }

  void updateName(String? name) {
    _logger.log(notifier, 'updateName');

    state = state.copyWith(name: name);
  }
}
