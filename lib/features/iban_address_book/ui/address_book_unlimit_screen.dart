import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/country_item/country_profile_item.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/show_user_data_country_picker.dart';
import 'package:jetwallet/features/iban_address_book/store/iban_address_book_store.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

@RoutePage(name: 'IbanAdressBookUnlimitRoute')
class IbanAdressBookUnlimitScreen extends StatelessWidget {
  const IbanAdressBookUnlimitScreen({
    Key? key,
    this.contact,
  }) : super(key: key);

  final AddressBookContactModel? contact;

  @override
  Widget build(BuildContext context) {
    return Provider<IbanAddressBookStore>(
      create: (context) => IbanAddressBookStore()
        ..setContact(contact)
        ..setFlow(false),
      builder: (context, child) => const _BodyAdressBookUnlimit(),
    );
  }
}

class _BodyAdressBookUnlimit extends StatelessObserverWidget {
  const _BodyAdressBookUnlimit({Key? key}) : super(key: key);

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
          title: store.isEditMode ? intl.address_book_edit_recipient : intl.address_book_add_recipient,
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
                    SFieldDividerFrame(
                      child: STransparentInkWell(
                        onTap: () {
                          showCountryOfBank(
                            context,
                            (country) {
                              store.setCountry(country);
                            },
                          );
                        },
                        child: SizedBox(
                          height: 88,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (store.country == null)
                                Text(
                                  intl.address_book_country_of_recepients_bank,
                                  style: sSubtitle2Style.copyWith(
                                    color: colors.grey2,
                                  ),
                                )
                              else ...[
                                Text(
                                  intl.address_book_country_of_recepients_bank,
                                  style: sCaptionTextStyle.copyWith(
                                    fontSize: 16.0,
                                    color: colors.grey2,
                                  ),
                                ),
                                CountryProfileItem(
                                  countryCode: store.country!.countryCode,
                                  countryName: store.country!.countryName,
                                  isBlocked: false,
                                  needPadding: false,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    SFieldDividerFrame(
                      child: SStandardField(
                        labelText: intl.iban_title,
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
                        labelText: intl.iban_bic,
                        textInputAction: TextInputAction.next,
                        controller: IbanAddressBookStore.of(context).bicController,
                        isError: IbanAddressBookStore.of(context).isIBANError,
                        onChanged: (text) {
                          IbanAddressBookStore.of(context).checkButton();
                        },
                        suffixIcons: [
                          SIconButton(
                            onTap: () {
                              IbanAddressBookStore.of(context).pasteBIC();

                              IbanAddressBookStore.of(context).checkButton();
                            },
                            defaultIcon: const SPasteIcon(),
                            pressedIcon: const SPastePressedIcon(),
                          ),
                        ],
                        hideSpace: true,
                      ),
                    ),
                    SFieldDividerFrame(
                      child: SStandardField(
                        labelText: intl.address_book_full_name,
                        textInputAction: TextInputAction.next,
                        controller: IbanAddressBookStore.of(context).fullnameController,
                        isError: IbanAddressBookStore.of(context).isIBANError,
                        onChanged: (text) {
                          IbanAddressBookStore.of(context).checkButton();
                        },
                        suffixIcons: [
                          SIconButton(
                            onTap: () {
                              IbanAddressBookStore.of(context).pasteFullName();

                              IbanAddressBookStore.of(context).checkButton();
                            },
                            defaultIcon: const SPasteIcon(),
                            pressedIcon: const SPastePressedIcon(),
                          ),
                        ],
                        hideSpace: true,
                      ),
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
