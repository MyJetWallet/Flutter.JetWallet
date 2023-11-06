import 'package:data_channel/data_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/kyc_profile_countries.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc_profile/country_list_response_model.dart';

part 'iban_address_book_store.g.dart';

class IbanAddressBookStore extends _IbanAddressBookStoreBase with _$IbanAddressBookStore {
  IbanAddressBookStore() : super();

  static IbanAddressBookStore of(BuildContext context) => Provider.of<IbanAddressBookStore>(context, listen: false);
}

abstract class _IbanAddressBookStoreBase with Store {
  bool isCJAddressBook = false;

  final TextEditingController labelController = TextEditingController();

  final TextEditingController ibanController = TextEditingController();

  final TextEditingController bicController = TextEditingController();

  final TextEditingController fullnameController = TextEditingController();

  @observable
  Country? country;
  @action
  void setCountry(Country c) => country = c;

  final loader = StackLoaderStore();

  @observable
  bool isIBANError = false;
  @action
  void serIsIBANError(bool val) => isIBANError = val;

  @observable
  bool isEditMode = false;
  @observable
  AddressBookContactModel? predContactData;
  @observable
  bool isButtonActive = false;

  @action
  void checkButton() {
    isButtonActive = isCJAddressBook
        ? labelController.text.isNotEmpty && ibanController.text.isNotEmpty
        : labelController.text.isNotEmpty &&
            ibanController.text.isNotEmpty &&
            bicController.text.isNotEmpty &&
            fullnameController.text.isNotEmpty &&
            country != null;
  }

  @action
  void setFlow(bool value) => isCJAddressBook = value;

  @action
  void setContact(AddressBookContactModel? contact) {
    if (contact != null) {
      predContactData = contact;
      isEditMode = true;

      final countriesList = getIt.get<KycProfileCountries>().profileCountries;

      labelController.text = predContactData!.name ?? '';
      ibanController.text = predContactData?.iban?.replaceAll(' ', '') ?? '';
      bicController.text = predContactData?.bic ?? '';
      fullnameController.text = predContactData?.fullName ?? '';
      country =
          countriesList.countries.firstWhere((element) => element.countryCode == (predContactData?.bankCountry ?? ''));

      checkButton();
    }
  }

  @action
  Future<void> pasteIban() async {
    final copiedText = await _copiedText();
    ibanController.text = copiedText.replaceAll(' ', '');

    _moveCursorAtTheEnd(ibanController);

    checkButton();
  }

  @action
  Future<void> pasteBIC() async {
    final copiedText = await _copiedText();
    bicController.text = copiedText.replaceAll(' ', '');

    _moveCursorAtTheEnd(bicController);

    checkButton();
  }

  @action
  Future<void> pasteFullName() async {
    final copiedText = await _copiedText();
    fullnameController.text = copiedText.replaceAll(' ', '');

    _moveCursorAtTheEnd(fullnameController);

    checkButton();
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

  ///

  @action
  Future<void> addAccount() async {
    loader.startLoadingImmediately();

    final DC<ServerRejectException, AddressBookContactModel>? response;

    response = isCJAddressBook
        ? await sNetwork.getWalletModule().postAddressBookAddSimple(
              labelController.text,
              ibanController.text.replaceAll(' ', ''),
            )
        : await sNetwork.getWalletModule().postAddressBookAddPersonal(
              labelController.text,
              ibanController.text.replaceAll(' ', ''),
              bicController.text,
              country?.countryCode ?? '',
              fullnameController.text,
            );

    response.pick(
      onData: (data) {
        getIt<IbanStore>().getAddressBook();

        getIt<AppRouter>().back();
      },
      onError: (error) {
        isIBANError = true;

        sNotification.showError(
          response?.error?.cause ?? '',
          duration: 4,
          id: 1,
          needFeedback: true,
        );

        loader.finishLoadingImmediately();
      },
    );

    loader.finishLoadingImmediately();
  }

  @action
  Future<void> editAccount() async {
    loader.startLoadingImmediately();

    try {
      final response = await sNetwork.getWalletModule().postAddressBookEdit(
            predContactData!.copyWith(
              name: labelController.text,
              iban: ibanController.text.replaceAll(' ', ''),
              bic: bicController.text,
            ),
          );

      if (response.hasError) {
        loader.finishLoadingImmediately();
        isIBANError = true;

        sNotification.showError(
          response.error?.cause ?? '',
          duration: 4,
          id: 1,
          needFeedback: true,
        );

        return;
      }

      await getIt<IbanStore>().getAddressBook();
      getIt<AppRouter>().back();

      sNotification.showError(
        intl.iban_edit_save_noty,
        duration: 4,
        id: 1,
        needFeedback: true,
        isError: false,
      );

      loader.finishLoadingImmediately();
    } catch (e) {
      loader.finishLoadingImmediately();
    }
  }

  @action
  Future<void> deleteAccount() async {
    loader.startLoadingImmediately();

    final response = await sNetwork.getWalletModule().postAddressBookDelete(
          predContactData!.id!,
        );

    if (response.hasError) {
      loader.finishLoadingImmediately();
      sNotification.showError(
        response.error?.cause ?? '',
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      return;
    }

    await getIt<IbanStore>().getAddressBook();
    getIt<AppRouter>().back();

    sNotification.showError(
      intl.iban_edit_delete_noty,
      duration: 4,
      id: 1,
      needFeedback: true,
      isError: false,
    );

    loader.finishLoadingImmediately();
  }
}
