import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../notifier/send_by_phone_input_notifier/send_by_phone_input_notipod.dart';

void showDialCodePicker(BuildContext context) {
  context.read(sendByPhoneInputNotipod.notifier).initDialCodeSearch();

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
    final notifier = useProvider(sendByPhoneInputNotipod.notifier);

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
    final state = useProvider(sendByPhoneInputNotipod);
    final notifier = useProvider(sendByPhoneInputNotipod.notifier);

    return Column(
      children: [
        for (final code in state.sortedDialCodes)
          SDialCodeItem(
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
