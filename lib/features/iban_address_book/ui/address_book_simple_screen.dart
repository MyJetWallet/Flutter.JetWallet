import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/iban/widgets/iban_terms_container.dart';
import 'package:jetwallet/features/iban_address_book/store/iban_address_book_store.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

@RoutePage(name: 'IbanAdressBookSimpleRoute')
class IbanAddressBookSimpleScreen extends StatelessWidget {
  const IbanAddressBookSimpleScreen({
    Key? key,
    this.contact,
  }) : super(key: key);

  final AddressBookContactModel? contact;

  @override
  Widget build(BuildContext context) {
    return Provider<IbanAddressBookStore>(
      create: (context) => IbanAddressBookStore()
        ..setContact(contact)
        ..setFlow(true),
      builder: (context, child) => const _BodyAddressBookSimple(),
    );
  }
}

class _BodyAddressBookSimple extends StatelessWidget {
  const _BodyAddressBookSimple({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = IbanAddressBookStore.of(context);

    final colors = sKit.colors;

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      loading: IbanAddressBookStore.of(context).loader,
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: store.isEditMode ? intl.iban_edit_bank_account : intl.iban_add_bank_account,
          showCloseButton: store.isEditMode,
          showBackButton: !store.isEditMode,
          onBackButtonTap: () => Navigator.pop(context, false),
          onCLoseButton: () => Navigator.pop(context, false),
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
                        controller: IbanAddressBookStore.of(context).labelController,
                        textInputAction: TextInputAction.next,
                        onChanged: (text) {
                          IbanAddressBookStore.of(context).checkButton();
                        },
                        hideSpace: true,
                      ),
                    ),
                    SFieldDividerFrame(
                      child: SStandardField(
                        labelText: intl.iban_account_number,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.next,
                        controller: IbanAddressBookStore.of(context).ibanController,
                        keyboardType: TextInputType.multiline,
                        onChanged: (text) {
                          IbanAddressBookStore.of(context).serIsIBANError(false);

                          IbanAddressBookStore.of(context).checkButton();
                        },
                        onErase: () {
                          IbanAddressBookStore.of(context).serIsIBANError(false);

                          IbanAddressBookStore.of(context).checkButton();
                        },
                        isError: IbanAddressBookStore.of(context).isIBANError,
                        suffixIcons: [
                          SIconButton(
                            onTap: () {
                              IbanAddressBookStore.of(context).pasteIban();

                              IbanAddressBookStore.of(context).checkButton();
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
                            active: IbanAddressBookStore.of(context).isButtonActive,
                            name: intl.iban_edit_save_changes,
                            onTap: () {
                              IbanAddressBookStore.of(context).editAccount();
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

                                  IbanAddressBookStore.of(context).deleteAccount();
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
                          child: SPrimaryButton2(
                            active: IbanAddressBookStore.of(context).isButtonActive,
                            name: intl.iban_add_account,
                            onTap: () {
                              sAnalytics.tapOnTheButtonAddAccount();

                              IbanAddressBookStore.of(context).addAccount();
                            },
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