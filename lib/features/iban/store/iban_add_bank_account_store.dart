import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
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

  @observable
  bool isButtonActive = false;
  @action
  void checkButton() {
    isButtonActive =
        labelController.text.isNotEmpty && ibanController.text.isNotEmpty;
  }

  @action
  Future<void> pasteIban() async {
    final copiedText = await _copiedText();
    ibanController.text = copiedText;

    _moveCursorAtTheEnd(ibanController);
  }

  @action
  Future<void> addAccount() async {
    final response = await sNetwork.getWalletModule().postAddressBookAdd(
          '${sUserInfo.firstName} ${sUserInfo.lastName}',
          labelController.text,
          ibanController.text,
        );

    response.pick(
      onData: (data) {
        print(data);

        getIt<AppRouter>().back();
      },
      onError: (error) {},
    );
  }

  Future<String> _copiedText() async {
    final data = await Clipboard.getData('text/plain');

    return (data?.text ?? '').replaceAll(' ', '');
  }

  @action
  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }
}
