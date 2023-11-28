import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/country_item/country_profile_item.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/show_user_data_country_picker.dart';
import 'package:jetwallet/features/iban/widgets/iban_item.dart';
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
        ..setFlow(false)
        ..setContact(contact),
      builder: (context, child) => const _BodyAdressBookUnlimit(),
    );
  }
}

class _BodyAdressBookUnlimit extends StatefulObserverWidget {
  const _BodyAdressBookUnlimit({Key? key}) : super(key: key);

  @override
  State<_BodyAdressBookUnlimit> createState() => _BodyAdressBookUnlimitState();
}

class _BodyAdressBookUnlimitState extends State<_BodyAdressBookUnlimit> {
  @override
  Widget build(BuildContext context) {
    final store = IbanAddressBookStore.of(context);

    final colors = sKit.colors;

    final mask = MaskTextInputFormatter(
      mask: '#### #### #### #### #### #### ####',
      initialText: IbanAddressBookStore.of(context).ibanController.text,
      filter: {
        '#': RegExp('[a-zA-Z0-9]'),
      },
    );

    return SPageFrame(
      loaderText: intl.loader_please_wait,
      loading: IbanAddressBookStore.of(context).loader,
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: store.isEditMode ? intl.address_book_edit_recipient : intl.address_book_add_recipient,
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
                          height: 80,
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (store.country == null)
                                Text(
                                  intl.address_book_country_of_recepients_bank,
                                  style: sSubtitle2Style.copyWith(
                                    fontSize: 18.0,
                                    color: colors.grey2,
                                  ),
                                )
                              else ...[
                                Text(
                                  intl.address_book_country_of_recepients_bank,
                                  style: sCaptionTextStyle.copyWith(
                                    fontSize: 12.0,
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
                      child: SizedBox(
                        child: SStandardField(
                          height: 80,
                          labelText: intl.iban_title,
                          textCapitalization: TextCapitalization.sentences,
                          textInputAction: TextInputAction.next,
                          controller: IbanAddressBookStore.of(context).ibanController,
                          keyboardType: TextInputType.multiline,
                          onChanged: (text) {
                            IbanAddressBookStore.of(context).setIsIBANError(false);
                            IbanAddressBookStore.of(context).checkButton();
                          },
                          onErase: () {
                            IbanAddressBookStore.of(context).setIsIBANError(false);
                            IbanAddressBookStore.of(context).checkButton();
                          },
                          isError: IbanAddressBookStore.of(context).isIBANError,
                          hideIconsIfNotEmpty: false,
                          suffixIcons: [
                            SIconButton(
                              onTap: () {
                                if (IbanAddressBookStore.of(context).ibanController.text.isEmpty) {
                                  IbanAddressBookStore.of(context).pasteIban().then((value) => setState(() {}));
                                  IbanAddressBookStore.of(context).checkButton();

                                  setState(() {});
                                } else {
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: IbanAddressBookStore.of(context).ibanController.text,
                                    ),
                                  );

                                  onCopyAction();
                                }
                              },
                              defaultIcon: const SPasteIcon(),
                              pressedIcon: const SPastePressedIcon(),
                            ),
                          ],
                          inputFormatters: [
                            if (IbanAddressBookStore.of(context).ibanMask != null)
                              IbanAddressBookStore.of(context).ibanMask!,
                          ],
                          hideSpace: true,
                        ),
                      ),
                    ),
                    SFieldDividerFrame(
                      child: SStandardField(
                        height: 80,
                        labelText: intl.iban_bic,
                        textInputAction: TextInputAction.next,
                        controller: IbanAddressBookStore.of(context).bicController,
                        isError: IbanAddressBookStore.of(context).isBICError,
                        onErase: () {
                          IbanAddressBookStore.of(context).setIsBICError(false);
                          IbanAddressBookStore.of(context).checkButton();
                        },
                        onChanged: (text) {
                          IbanAddressBookStore.of(context).setIsBICError(false);
                          IbanAddressBookStore.of(context).checkButton();
                        },
                        hideIconsIfNotEmpty: false,
                        suffixIcons: [
                          SIconButton(
                            onTap: () {
                              if (IbanAddressBookStore.of(context).bicController.text.isEmpty) {
                                IbanAddressBookStore.of(context).pasteBIC().then((value) => setState(() {}));
                              } else {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: IbanAddressBookStore.of(context).bicController.text,
                                  ),
                                );

                                onCopyAction();
                              }
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
                        height: 80,
                        labelText: intl.address_book_full_name,
                        textInputAction: TextInputAction.next,
                        controller: IbanAddressBookStore.of(context).fullnameController,
                        isError: IbanAddressBookStore.of(context).isFullNameError,
                        onChanged: (text) {
                          IbanAddressBookStore.of(context).checkButton();
                        },
                        hideIconsIfNotEmpty: false,
                        suffixIcons: [
                          SIconButton(
                            onTap: () {
                              if (IbanAddressBookStore.of(context).fullnameController.text.isEmpty) {
                                IbanAddressBookStore.of(context).pasteFullName().then((value) => setState(() {}));
                                IbanAddressBookStore.of(context).checkButton();
                              } else {
                                Clipboard.setData(
                                  ClipboardData(
                                    text: IbanAddressBookStore.of(context).fullnameController.text,
                                  ),
                                );

                                onCopyAction();
                              }
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
                        height: 80,
                        labelText: intl.iban_label,
                        maxLines: 1,
                        maxLength: 30,
                        controller: IbanAddressBookStore.of(context).labelController,
                        textInputAction: TextInputAction.next,
                        isError: IbanAddressBookStore.of(context).isLabelError,
                        onErase: () {
                          IbanAddressBookStore.of(context).setLabelError(false);
                          IbanAddressBookStore.of(context).checkButton();
                        },
                        onChanged: (text) {
                          IbanAddressBookStore.of(context).setLabelError(false);
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
                      const SizedBox(height: 8),
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
                            name: intl.create_continue,
                            onTap: () {
                              sAnalytics.tapOnTheButtonAddAccount();

                              IbanAddressBookStore.of(context).addAccount();
                            },
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 48),
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
