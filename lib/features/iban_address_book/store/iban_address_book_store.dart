import 'package:data_channel/data_channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/kyc_profile_countries.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
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
  void setCountry(Country c) {
    country = c;
    checkButton();
  }

  final loader = StackLoaderStore();

  MaskTextInputFormatter? ibanMask;

  @observable
  bool isIBANError = false;
  @action
  void setIsIBANError(bool val) => isIBANError = val;

  @observable
  bool isBICError = false;
  @action
  void setIsBICError(bool val) => isBICError = val;

  @observable
  bool isFullNameError = false;
  @action
  void setIsFullNameError(bool val) => isFullNameError = val;

  @observable
  bool isLabelError = false;
  @action
  void setLabelError(bool val) => isLabelError = val;

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

      ibanMask = MaskTextInputFormatter(
        mask: '#### #### #### #### #### #### #### #### ##',
        initialText: ibanController.text,
        filter: {
          '#': RegExp('[a-zA-Z0-9]'),
        },
        type: MaskAutoCompletionType.eager,
      );

      ibanController.text = ibanMask!.maskText(ibanController.text);

      final countryIndex = countriesList.countries.indexWhere(
        (element) => element.countryCode == (predContactData?.bankCountry ?? ''),
      );
      if (countryIndex != -1) {
        country = countriesList.countries[countryIndex];
      }

      checkButton();
    } else {
      ibanMask = MaskTextInputFormatter(
        mask: '#### #### #### #### #### #### #### #### ##',
        initialText: ibanController.text,
        filter: {
          '#': RegExp('[a-zA-Z0-9]'),
        },
        type: MaskAutoCompletionType.eager,
      );
    }
  }

  @action
  Future<void> pasteIban() async {
    final copiedText = await _copiedText();
    ibanController.text = copiedText.replaceAll(' ', '');

    ibanMask = MaskTextInputFormatter(
      mask: '#### #### #### #### #### #### #### #### ##',
      initialText: ibanController.text,
      filter: {
        '#': RegExp('[a-zA-Z0-9]'),
      },
      type: MaskAutoCompletionType.eager,
    );
    ibanController.text = ibanMask!.maskText(ibanController.text);

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
    final copiedText = await _copiedText(trim: false);
    fullnameController.text = copiedText;

    _moveCursorAtTheEnd(fullnameController);

    checkButton();
  }

  Future<String> _copiedText({bool trim = true}) async {
    final data = await Clipboard.getData('text/plain');

    return trim ? (data?.text ?? '').replaceAll(' ', '') : data?.text ?? '';
  }

  @action
  void _moveCursorAtTheEnd(TextEditingController controller) {
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  ///

  @action
  Future<bool> addAccount() async {
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

    if (response.hasError) {
      isIBANError = response.error?.errorCode == 'ContactWithThisIbanAlreadyExists';
      isIBANError = response.error?.errorCode == 'InvalidIban';
      isBICError = response.error?.errorCode == 'InvalidBic';
      isLabelError = response.error?.errorCode == 'ContactWithThisNameAlreadyExists';

      sNotification.showError(
        response.error?.cause ?? intl.something_went_wrong,
        id: 1,
        needFeedback: true,
      );

      loader.finishLoadingImmediately();

      return false;
    } else {
      await getIt<IbanStore>().getAddressBook();

      return true;
    }
  }

  @action
  Future<bool> editAccount() async {
    loader.startLoadingImmediately();

    try {
      final response = await sNetwork.getWalletModule().postAddressBookEdit(
            predContactData!.copyWith(
              name: labelController.text,
              iban: ibanController.text.replaceAll(' ', ''),
              bic: bicController.text,
              bankCountry: country?.countryCode ?? '',
              fullName: fullnameController.text,
            ),
          );

      if (response.hasError) {
        loader.finishLoadingImmediately();

        isIBANError = response.error?.errorCode == 'ContactWithThisIbanAlreadyExists';
        isIBANError = response.error?.errorCode == 'InvalidIban';
        isBICError = response.error?.errorCode == 'InvalidBic';
        isLabelError = response.error?.errorCode == 'ContactWithThisNameAlreadyExists';

        sNotification.showError(
          response.error?.cause ?? intl.something_went_wrong,
          id: 1,
          needFeedback: true,
        );

        return false;
      }

      await getIt<IbanStore>().getAddressBook();

      sNotification.showError(
        intl.iban_edit_save_noty,
        id: 1,
        needFeedback: true,
        isError: false,
      );

      loader.finishLoadingImmediately();

      return true;
    } catch (e) {
      loader.finishLoadingImmediately();

      return false;
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
        response.error?.cause ?? intl.something_went_wrong,
        id: 1,
        needFeedback: true,
      );

      return;
    }

    await getIt<IbanStore>().getAddressBook();
    getIt<AppRouter>().back();

    sNotification.showError(
      intl.iban_edit_delete_noty,
      id: 1,
      needFeedback: true,
      isError: false,
    );

    loader.finishLoadingImmediately();
  }
}
