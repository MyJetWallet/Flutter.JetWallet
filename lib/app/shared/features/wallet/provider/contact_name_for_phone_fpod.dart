import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';

final contactNameForPhoneFpod =
    FutureProvider.family.autoDispose<String?, String>((ref, phone) async {
  final contactsService = ref.read(contactsServicePod);
  String? contactName;

  await contactsService.askPermission(
    onGranted: () async {
      final contact = await contactsService.contactForPhone(phone);
      contactName = contact.displayName;
    },
    onDenied: () {
      // TODO(Vova): add handling of denied contacts permission?
    },
  );

  return contactName;
});
