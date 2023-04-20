import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';

part 'iban_add_bank_account_store.g.dart';

class IbanAddBankAccountStore extends _IbanAddBankAccountStoreBase
    with _$IbanAddBankAccountStore {
  IbanAddBankAccountStore() : super();

  static IbanAddBankAccountStore of(BuildContext context) =>
      Provider.of<IbanAddBankAccountStore>(context, listen: false);
}

abstract class _IbanAddBankAccountStoreBase with Store {
  final TextEditingController labelController = TextEditingController();

  final TextEditingController ibanController = TextEditingController();

  final loader = StackLoaderStore();
}
