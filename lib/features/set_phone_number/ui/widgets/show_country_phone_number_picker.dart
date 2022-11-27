import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/set_phone_number/store/set_phone_number_store.dart';
import 'package:jetwallet/widgets/dial_code_item.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

void showCountryPhoneNumberPicker(BuildContext context) {
  getIt.get<SetPhoneNumberStore>().initDialCodeSearch();

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

class _SearchPinned extends StatelessObserverWidget {
  const _SearchPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = getIt.get<SetPhoneNumberStore>();

    return SStandardField(
      autofocus: true,
      labelText: intl.showCountryPhoneNumberPicker_searchCountry,
      onChanged: (value) {
        store.updateDialCodeSearch(value);
      },
    );
  }
}

class _DialCodes extends StatelessObserverWidget {
  const _DialCodes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = getIt.get<SetPhoneNumberStore>();

    return ListView.builder(
      itemCount: store.sortedDialCodes.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int code) {
        return DialCodeItem(
          dialCode: store.sortedDialCodes[code],
          active: store.activeDialCode?.isoCode ==
              store.sortedDialCodes[code].isoCode,
          onTap: () {
            sAnalytics.changeCountryCode(
              store.sortedDialCodes[code].countryName,
            );
            store.pickDialCodeFromSearch(store.sortedDialCodes[code]);

            sRouter.pop();
          },
        );
      },
    );
  }
}
