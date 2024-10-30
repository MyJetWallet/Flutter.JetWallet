import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/anchors/anchors_helper.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/country_item/country_profile_item.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/show_user_data_country_picker.dart';
import 'package:jetwallet/features/iban/widgets/iban_item.dart';
import 'package:jetwallet/features/iban_address_book/store/iban_address_book_store.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

@RoutePage(name: 'IbanAdressBookUnlimitRoute')
class IbanAdressBookUnlimitScreen extends StatelessWidget {
  const IbanAdressBookUnlimitScreen({
    super.key,
    this.contact,
    this.bankingAccount,
  });

  final AddressBookContactModel? contact;
  final SimpleBankingAccount? bankingAccount;

  @override
  Widget build(BuildContext context) {
    return Provider<IbanAddressBookStore>(
      create: (context) => IbanAddressBookStore()
        ..setFlow(false)
        ..setContact(contact),
      builder: (context, child) => _BodyAdressBookUnlimit(
        bankingAccount: bankingAccount,
      ),
    );
  }
}

class _BodyAdressBookUnlimit extends StatefulObserverWidget {
  const _BodyAdressBookUnlimit({
    this.bankingAccount,
  });

  final SimpleBankingAccount? bankingAccount;

  @override
  State<_BodyAdressBookUnlimit> createState() => _BodyAdressBookUnlimitState();
}

class _BodyAdressBookUnlimitState extends State<_BodyAdressBookUnlimit> {
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
                          child: SButton.black(
                            text: intl.iban_edit_save_changes,
                            callback: IbanAddressBookStore.of(context).isButtonActive
                                ? () async {
                                    sAnalytics.eurWithdrawTapSaveChangesEdit(
                                      isCJ: false,
                                      accountIban: widget.bankingAccount?.iban ?? '',
                                      accountLabel: widget.bankingAccount?.label ?? '',
                                    );

                                    final result = await IbanAddressBookStore.of(context).editAccount();

                                    if (result) {
                                      Navigator.pop(context, true);
                                    }
                                  }
                                : null,
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
                              sAnalytics.eurWithdrawTapDeleteEdit(
                                isCJ: false,
                                accountIban: widget.bankingAccount?.iban ?? '',
                                accountLabel: widget.bankingAccount?.label ?? '',
                              );

                              sShowAlertPopup(
                                context,
                                primaryText: '${intl.iban_edit_delete_account}?',
                                secondaryText: intl.iban_edit_delete_account_descr,
                                primaryButtonName: intl.iban_edit_delete,
                                primaryButtonType: SButtonType.primary3,
                                onPrimaryButtonTap: () {
                                  sAnalytics.eurWithdrawTapConfirmDeleteEdit(
                                    isCJ: false,
                                    accountIban: widget.bankingAccount?.iban ?? '',
                                    accountLabel: widget.bankingAccount?.label ?? '',
                                  );

                                  Navigator.pop(context, false);

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
                          child: SButton.blue(
                            text: intl.create_continue,
                            callback: IbanAddressBookStore.of(context).isButtonActive
                                ? () async {
                                    sAnalytics.eurWithdrawTapContinueAddReceiving(
                                      isCJ: false,
                                      accountIban: widget.bankingAccount?.iban ?? '',
                                      accountLabel: widget.bankingAccount?.label ?? '',
                                    );

                                    final result = await IbanAddressBookStore.of(context).addAccount();

                                    if (result) {
                                      if (!store.isEditMode) {
                                        await AnchorsHelper().addAddExternalIbanAnchor(
                                          widget.bankingAccount?.accountId ?? 'clearjuction_account',
                                        );
                                      }

                                      if (Navigator.canPop(context)) {
                                        Navigator.pop(context, true);
                                      }
                                    }
                                  }
                                : null,
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
