import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

part 'iban_send_store.g.dart';

class IbanSendStore extends _IbanSendStoreBase with _$IbanSendStore {
  IbanSendStore() : super();

  static IbanSendStore of(BuildContext context) =>
      Provider.of<IbanSendStore>(context, listen: false);
}

abstract class _IbanSendStoreBase with Store {
  @observable
  ObservableList<AddressBookContactModel> contacts = ObservableList.of([]);

  @observable
  ObservableList<AddressBookContactModel> topContacts = ObservableList.of([]);

  @action
  Future<void> getAddressBook() async {
    print('getAddressBook');

    final response = await sNetwork.getWalletModule().getAddressBook('');

    response.pick(
      onData: (data) {
        contacts = ObservableList.of(data.contacts ?? []);
        topContacts = ObservableList.of(data.topContacts ?? []);
      },
    );

    contacts.sort((a, b) {
      return b.weight!.compareTo(a.weight!);
    });
  }
}
