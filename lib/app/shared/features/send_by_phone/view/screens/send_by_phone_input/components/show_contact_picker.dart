
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../notifier/send_by_phone_input_notifier/send_by_phone_input_notipod.dart';

void showContactPicker(BuildContext context) {
  context.read(sendByPhoneInputNotipod.notifier).initPhoneSearch();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _SearchPinned(),
    expanded: true,
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      const _Contacts(),
      const SpaceH24(),
    ],
  );
}

class _SearchPinned extends HookWidget {
  const _SearchPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = context.read(intlPod);
    final state = context.read(sendByPhoneInputNotipod);
    final notifier = useProvider(sendByPhoneInputNotipod.notifier);

    return SStandardField(
      autofocus: true,
      labelText: intl.showContactPicker_phoneNumber,
      initialValue: state.phoneSearch,
      onChanged: (value) {
        notifier.updatePhoneSearch(value);
      },
    );
  }
}

class _Contacts extends HookWidget {
  const _Contacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(sendByPhoneInputNotipod);
    final notifier = useProvider(sendByPhoneInputNotipod.notifier);

     return SizedBox(
       height: MediaQuery.of(context).size.height,
       child: ListView.builder(
          itemCount: state.sortedContacts.length,
          itemBuilder: (BuildContext context, int index) {
            return SContactItem(
              name: state.sortedContacts[index].name,
              phone: state.sortedContacts[index].phoneNumber,
              valid: state.sortedContacts[index].valid,
              isManualEnter: contact.isCustomContact,
              onTap: () {
                notifier.pickNumberFromSearch(state.sortedContacts[index]);
                Navigator.pop(context);
              },
            );
          },),
     );
  }
}
