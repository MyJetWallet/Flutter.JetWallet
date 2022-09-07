import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_input_store.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

void showContactPicker(
  BuildContext context,
) {
  final store = getIt.get<SendByPhoneInputStore>();

  store.initPhoneSearch();

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
      _Contacts(
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
      labelText: intl.showContactPicker_phoneNumber,
      initialValue: store.phoneSearch,
      onChanged: (value) {
        store.updatePhoneSearch(value);
      },
    );
  }
}

class _Contacts extends StatelessObserverWidget {
  const _Contacts({
    Key? key,
    required this.store,
  }) : super(key: key);

  final SendByPhoneInputStore store;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: store.sortedContacts.length,
        itemBuilder: (BuildContext context, int index) {
          return SContactItem(
            name: store.sortedContacts[index].name,
            phone: store.sortedContacts[index].phoneNumber,
            valid: store.sortedContacts[index].valid,
            isManualEnter: store.sortedContacts[index].isCustomContact,
            onTap: () {
              store.pickNumberFromSearch(store.sortedContacts[index]);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
