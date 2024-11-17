import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/set_phone_number/store/set_phone_number_store.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/dial_code_item.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void showCountryPhoneNumberPicker(BuildContext context) {
  Provider.of<SetPhoneNumberStore>(context, listen: false).initDialCodeSearch();
  final store = Provider.of<SetPhoneNumberStore>(context, listen: false);
  showBasicBottomSheet(
    context: context,
    expanded: true,
    header: BasicBottomSheetHeaderWidget(
      searchOptions: SearchOptions(
        hint: intl.showCountryPhoneNumberPicker_searchCountry,
        onChange: (String value) {
          store.updateDialCodeSearch(value);
        },
      ),
    ),
    children: [
      _DialCodes(context: context),
      const SpaceH24(),
    ],
  );
}

class _DialCodes extends StatelessObserverWidget {
  const _DialCodes({required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext con) {
    final store = Provider.of<SetPhoneNumberStore>(context, listen: false);

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: store.sortedDialCodes.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (BuildContext context, int code) {
        return DialCodeItem(
          dialCode: store.sortedDialCodes[code],
          active: store.activeDialCode?.isoCode == store.sortedDialCodes[code].isoCode,
          onTap: () {
            store.pickDialCodeFromSearch(store.sortedDialCodes[code]);

            sRouter.maybePop();
          },
        );
      },
    );
  }
}
