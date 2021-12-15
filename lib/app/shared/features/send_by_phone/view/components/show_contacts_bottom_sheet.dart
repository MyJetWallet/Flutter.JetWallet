import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../notifier/send_by_phone_input_notifier/send_by_phone_input_notipod.dart';

void showContactsBottomSheet(BuildContext context) {
  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _ContactsPinned(),
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      const _Contacts(),
      const SpaceH24(),
    ],
  );
}

class _ContactsPinned extends StatelessWidget {
  const _ContactsPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SStandardField(
      labelText: 'Phone number',
    );
  }
}

class _Contacts extends HookWidget {
  const _Contacts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(sendByPhoneInputNotipod);

    return Column(
      children: [
        for (final contact in state.contacts)
          SContactItem(
            name: contact.name,
            phone: contact.phoneNumber,
            onTap: () {},
          )
      ],
    );
  }
}
