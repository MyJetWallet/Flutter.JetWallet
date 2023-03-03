import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_input_store.dart';
import 'package:jetwallet/utils/helpers/country_code_by_user_register.dart';
import 'package:jetwallet/widgets/dial_code_item.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

void showDialCodePicker(
  BuildContext context,
) {
  final store = getIt.get<SendByPhoneInputStore>();

  store.initDialCodeSearch();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: _SearchPinned(
      store: store,
    ),
    expanded: true,
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      _DialCodes(
        store: store,
      ),
      const SpaceH24(),
    ],
  );
}

class _SearchPinned extends StatelessObserverWidget {
  const _SearchPinned({
    Key? key,
    required this.store,
  }) : super(key: key);

  final SendByPhoneInputStore store;

  @override
  Widget build(BuildContext context) {
    return SStandardField(
      autofocus: true,
      focusNode: FocusNode(),
      labelText: intl.showDialCodePicker_searchCountry,
      onChanged: (value) {
        store.updateDialCodeSearch(value);

        /*
        store.searchTextController.selection = TextSelection.collapsed(
          offset: store.searchTextController.text.length,
        );
        */
      },
    );
  }
}

class _DialCodes extends StatelessObserverWidget {
  const _DialCodes({
    Key? key,
    required this.store,
  }) : super(key: key);

  final SendByPhoneInputStore store;

  @override
  Widget build(BuildContext context) {
    final userCountryCode = store.sortedDialCodes
        .where(
          (element) =>
              element.countryCode == countryCodeByUserRegister()?.countryCode,
        )
        .toList();

    return Column(
      children: [
        if (userCountryCode.isNotEmpty) ...[
          DialCodeItem(
            dialCode: userCountryCode[0],
            active: store.activeDialCode?.isoCode == userCountryCode[0].isoCode,
            onTap: () {
              store.pickDialCodeFromSearch(userCountryCode[0]);

              sRouter.pop();
            },
          ),
        ],
        ListView.builder(
          shrinkWrap: true,
          itemCount: store.sortedDialCodes.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final code = store.sortedDialCodes[index];

            return code.countryCode != countryCodeByUserRegister()?.countryCode
                ? DialCodeItem(
                    dialCode: code,
                    active: store.activeDialCode?.isoCode == code.isoCode,
                    onTap: () {
                      store.pickDialCodeFromSearch(code);
                      sRouter.pop();
                    },
                  )
                : const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}
