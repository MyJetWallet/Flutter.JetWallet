import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/iban/store/iban_add_bank_account_store.dart';
import 'package:jetwallet/features/iban/widgets/iban_terms_container.dart';
import 'package:logger/logger.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

@RoutePage(name: 'IbanAddBankAccountRouter')
class IbanAddBankAccountScreen extends StatelessWidget {
  const IbanAddBankAccountScreen({
    super.key,
    this.contact,
  });

  final AddressBookContactModel? contact;

  @override
  Widget build(BuildContext context) {
    return Provider<IbanAddBankAccountStore>(
      create: (context) => IbanAddBankAccountStore()..setContact(contact),
      builder: (context, child) => const IbanAddBankAccountScreenBody(),
    );
  }
}

@RoutePage(name: 'IbanEditBankAccountRouter')
class IbanEditBankAccountScreen extends StatelessWidget {
  const IbanEditBankAccountScreen({
    super.key,
    this.contact,
  });

  final AddressBookContactModel? contact;

  @override
  Widget build(BuildContext context) {
    return Provider<IbanAddBankAccountStore>(
      create: (context) => IbanAddBankAccountStore()..setContact(contact),
      builder: (context, child) => const IbanAddBankAccountScreenBody(),
    );
  }
}

class IbanAddBankAccountScreenBody extends StatelessObserverWidget {
  const IbanAddBankAccountScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = IbanAddBankAccountStore.of(context);

    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'Iban Add Bank Account Screen',
          message: sUserInfo.toString(),
        );

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      loading: IbanAddBankAccountStore.of(context).loader,
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: store.isEditMode ? intl.iban_edit_bank_account : intl.iban_add_bank_account,
          showCloseButton: store.isEditMode,
          showBackButton: !store.isEditMode,
          onBackButtonTap: () => Navigator.pop(context),
          onCLoseButton: () => Navigator.pop(context),
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: AutofillGroup(
              child: FocusScope(
                autofocus: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IbanTermsContainer(
                      text1: intl.iban_terms_1,
                      text2: intl.iban_terms_4,
                      addAccount: true,
                    ),
                    SFieldDividerFrame(
                      child: SStandardField(
                        labelText: intl.iban_label,
                        maxLines: 1,
                        maxLength: 30,
                        controller: IbanAddBankAccountStore.of(context).labelController,
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          IbanAddBankAccountStore.of(context).checkButton();
                        },
                        hideSpace: true,
                      ),
                    ),
                    SFieldDividerFrame(
                      child: SStandardField(
                        labelText: intl.iban_account_number,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        controller: IbanAddBankAccountStore.of(context).ibanController,
                        keyboardType: TextInputType.multiline,
                        onChanged: (text) {
                          IbanAddBankAccountStore.of(context).serIsIBANError(false);

                          IbanAddBankAccountStore.of(context).checkButton();
                        },
                        onErase: () {
                          IbanAddBankAccountStore.of(context).serIsIBANError(false);

                          IbanAddBankAccountStore.of(context).checkButton();
                        },
                        isError: IbanAddBankAccountStore.of(context).isIBANError,
                        suffixIcons: [
                          SIconButton(
                            onTap: () {
                              IbanAddBankAccountStore.of(context).pasteIban();

                              IbanAddBankAccountStore.of(context).checkButton();
                            },
                            defaultIcon: const SPasteIcon(),
                            pressedIcon: const SPastePressedIcon(),
                          ),
                        ],
                        inputFormatters: [
                          MaskTextInputFormatter(
                            mask: '#### #### #### #### #### #### ####',
                            filter: {
                              '#': RegExp('[a-zA-Z0-9]'),
                            },
                          ),
                        ],
                        hideSpace: true,
                      ),
                    ),
                    SFieldDividerFrame(
                      child: SStandardField(
                        controller: TextEditingController(
                          text: '${sUserInfo.firstName} ${sUserInfo.lastName}',
                        ),
                        readOnly: true,
                        enabled: false,
                        hideClearButton: true,
                        labelText: intl.iban_benificiary,
                        textCapitalization: TextCapitalization.sentences,
                        hideSpace: true,
                        grayLabel: true,
                      ),
                    ),
                    const SpaceH20(),
                    const Spacer(),
                    if (store.isEditMode) ...[
                      SPaddingH24(
                        child: Material(
                          color: colors.grey5,
                          child: SPrimaryButton1(
                            active: IbanAddBankAccountStore.of(context).isButtonActive,
                            name: intl.iban_edit_save_changes,
                            onTap: () {
                              IbanAddBankAccountStore.of(context).editAccount();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SPaddingH24(
                        child: Material(
                          color: colors.grey5,
                          child: STextButton1(
                            active: true,
                            name: intl.iban_edit_delete_account,
                            onTap: () {
                              sShowAlertPopup(
                                context,
                                primaryText: '${intl.iban_edit_delete_account}?',
                                secondaryText: intl.iban_edit_delete_account_descr,
                                primaryButtonName: intl.iban_edit_delete,
                                primaryButtonType: SButtonType.primary3,
                                onPrimaryButtonTap: () {
                                  Navigator.pop(context);

                                  IbanAddBankAccountStore.of(context).deleteAccount();
                                },
                                isNeedCancelButton: true,
                                cancelText: intl.profileDetails_cancel,
                                onCancelButtonTap: () => {Navigator.pop(context)},
                              );
                            },
                          ),
                        ),
                      ),
                    ] else ...[
                      SPaddingH24(
                        child: Material(
                          color: colors.grey5,
                          child: SButton.blue(
                            text: intl.iban_add_account,
                            callback: IbanAddBankAccountStore.of(context).isButtonActive
                                ? () {
                                    IbanAddBankAccountStore.of(context).addAccount();
                                  }
                                : null,
                          ),
                        ),
                      ),
                    ],
                    const SpaceH42(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
