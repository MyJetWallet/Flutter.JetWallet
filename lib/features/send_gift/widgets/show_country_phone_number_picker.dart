import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/set_phone_number/store/set_phone_number_store.dart';
import 'package:jetwallet/widgets/dial_code_item.dart';

import 'package:simple_kit/simple_kit.dart';

void showGiftCountryPhoneNumberPicker(
  BuildContext context,
  SetPhoneNumberStore store,
) {
  store.initDialCodeSearch();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: _SearchPinned(
      context: context,
      store: store,
    ),
    expanded: true,
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      _DialCodes(
        context: context,
        store: store,
      ),
      const SpaceH24(),
    ],
  );
}

class _SearchPinned extends StatelessObserverWidget {
  const _SearchPinned({
    required this.store,
    required this.context,
  });
  final BuildContext context;
  final SetPhoneNumberStore store;

  @override
  Widget build(BuildContext con) {
    return SStandardField(
      controller: TextEditingController(),
      autofocus: true,
      labelText: intl.showCountryPhoneNumberPicker_searchCountry,
      onChanged: (value) {
        store.updateDialCodeSearch(value);
      },
    );
  }
}

class _DialCodes extends StatelessObserverWidget {
  const _DialCodes({
    required this.store,
    required this.context,
  });

  final BuildContext context;
  final SetPhoneNumberStore store;

  @override
  Widget build(BuildContext con) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: store.sortedDialCodes.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int code) {
        return DialCodeItem(
          dialCode: store.sortedDialCodes[code],
          active: store.activeDialCode?.isoCode ==
              store.sortedDialCodes[code].isoCode,
          onTap: () {
            store.pickDialCodeFromSearch(store.sortedDialCodes[code]);

            sRouter.maybePop();
          },
        );
      },
    );
  }
}
