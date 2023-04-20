import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'iban_add_bank_account_store.g.dart';

class IbanAddBankAccountStore extends _IbanAddBankAccountStoreBase
    with _$IbanAddBankAccountStore {
  IbanAddBankAccountStore() : super();

  static IbanAddBankAccountStore of(BuildContext context) =>
      Provider.of<IbanAddBankAccountStore>(context, listen: false);
}

abstract class _IbanAddBankAccountStoreBase with Store {}
