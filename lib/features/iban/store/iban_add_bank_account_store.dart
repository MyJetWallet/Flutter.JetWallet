import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

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

  @observable
  bool isIBANError = false;
  @action
  void serIsIBANError(bool val) => isIBANError = val;

  @observable
  bool isEditMode = false;
  @observable
  AddressBookContactModel? predContactData;

  final loader = StackLoaderStore();

  @observable
  bool isButtonActive = false;
  @action
  void checkButton() {
    isButtonActive =
        labelController.text.isNotEmpty && ibanController.text.isNotEmpty;
  }

  @action
  void setContact(AddressBookContactModel? contact) {
    if (contact != null) {
      predContactData = contact;
      isEditMode = true;

      labelController.text = predContactData!.name ?? '';
      ibanController.text = predContactData!.iban ?? '';

      checkButton();
    }
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
          labelController.text,
          '${sUserInfo.firstName} ${sUserInfo.lastName}',
          ibanController.text,
        );

    response.pick(
      onData: (data) {
        getIt<AppRouter>().back();
      },
      onError: (error) {
        isIBANError = true;

        sNotification.showError(
          response.error?.cause ?? '',
          duration: 4,
          id: 1,
          needFeedback: true,
        );
      },
    );
  }

  @action
  Future<void> editAccount() async {
    final response = await sNetwork.getWalletModule().postAddressBookEdit(
          predContactData!.copyWith(
            name: labelController.text,
            iban: ibanController.text,
          ),
        );

    if (response.hasError) {
      isIBANError = true;

      sNotification.showError(
        response.error?.cause ?? '',
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      return;
    }

    getIt<AppRouter>().back();

    sNotification.showError(
      intl.iban_edit_save_noty,
      duration: 4,
      id: 1,
      needFeedback: true,
      isError: false,
    );
  }

  @action
  Future<void> deleteAccount() async {
    final response = await sNetwork.getWalletModule().postAddressBookDelete(
          predContactData!.id!,
        );

    if (response.hasError) {
      sNotification.showError(
        response.error?.cause ?? '',
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      return;
    }

    getIt<AppRouter>().back();

    sNotification.showError(
      intl.iban_edit_delete_noty,
      duration: 4,
      id: 1,
      needFeedback: true,
      isError: false,
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
