import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../send_by_phone/view/screens/send_by_phone_input/components/show_dial_code_picker/components/dial_code_item.dart';
import '../../notifier/phone_number_notipod.dart';

void showCountryPhoneNumberPicker(BuildContext context) {
  context.read(phoneNumberNotipod.notifier).initDialCodeSearch();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _SearchPinned(),
    expanded: true,
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      const _DialCodes(),
      const SpaceH24(),
    ],
  );
}

class _SearchPinned extends HookWidget {
  const _SearchPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = useProvider(phoneNumberNotipod.notifier);

    return SStandardField(
      autofocus: true,
      labelText: 'Search country',
      onChanged: (value) {
        notifier.updateDialCodeSearch(value);
      },
    );
  }
}

class _DialCodes extends HookWidget {
  const _DialCodes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(phoneNumberNotipod);
    final notifier = useProvider(phoneNumberNotipod.notifier);

    return Column(
      children: [
        for (final code in state.sortedDialCodes)
          DialCodeItem(
            dialCode: code,
            active: state.activeDialCode?.isoCode == code.isoCode,
            onTap: () {
              notifier.pickDialCodeFromSearch(code);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
