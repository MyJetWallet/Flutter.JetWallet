import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/service_providers.dart';
import '../../../../components/dial_code_item.dart';
import '../../notifier/set_phone_number_notipod.dart';

void showCountryPhoneNumberPicker(BuildContext context) {
  context.read(setPhoneNumberNotipod.notifier).initDialCodeSearch();

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
    final intl = useProvider(intlPod);
    final notifier = useProvider(setPhoneNumberNotipod.notifier);

    return SStandardField(
      autofocus: true,
      labelText: intl.showCountryPhoneNumberPicker_searchCountry,
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
    final state = useProvider(setPhoneNumberNotipod);
    final notifier = useProvider(setPhoneNumberNotipod.notifier);

    return Column(
      children: [
        for (final code in state.sortedDialCodes)
          DialCodeItem(
            dialCode: code,
            active: state.activeDialCode?.isoCode == code.isoCode,
            onTap: () {
              sAnalytics.changeCountryCode(code.countryName);

              notifier.pickDialCodeFromSearch(code);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}
