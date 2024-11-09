import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:jetwallet/features/iban/widgets/show_choose_asset_to_send.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';

void showBankTransforSelect(
  BuildContext context,
  SimpleBankingAccount bankingAccount,
  bool isCJ, [
  bool isSendFlow = false,
  CurrencyModel? currency,
]) {
  if (isCJ ? getIt.get<IbanStore>().simpleContacts.isEmpty : getIt.get<IbanStore>().allContacts.isEmpty) {
    if (isCJ) {
      sRouter.push(IbanAdressBookSimpleRoute()).then((value) async {
        await getIt.get<IbanStore>().getAddressBook();

        if (value == null) {
          return;
        }

        if (!(value as bool)) {
          return;
        }

        if (isSendFlow) {
          await context.router.maybePop();

          if (currency != null) {
            await getIt<AppRouter>().push(
              IbanSendAmountRouter(
                isCJ: isCJ,
                contact: (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
                currency: currency,
              ),
            );
          } else {
            showChooseAssetToSend(
              sRouter.navigatorKey.currentContext!,
              contact: (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
              isCJ: isCJ,
            );
          }
        } else {
          await getIt<AppRouter>()
              .push(
                IbanSendAmountRouter(
                  contact: (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
                  bankingAccount: bankingAccount,
                  isCJ: isCJ,
                ),
              )
              .then(
                (value) => getIt.get<IbanStore>().getAddressBook(),
              );
        }
      });
    } else {
      sRouter.push(IbanAdressBookUnlimitRoute()).then((value) async {
        await getIt.get<IbanStore>().getAddressBook();

        if (value == null) {
          return;
        }
        if (!(value as bool)) {
          return;
        }

        if (isSendFlow) {
          await context.router.maybePop();

          if (currency != null) {
            await getIt<AppRouter>().push(
              IbanSendAmountRouter(
                isCJ: isCJ,
                contact: (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
                currency: currency,
              ),
            );
          } else {
            showChooseAssetToSend(
              sRouter.navigatorKey.currentContext!,
              contact: (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
              isCJ: isCJ,
            );
          }
        } else {
          await getIt<AppRouter>()
              .push(
                IbanSendAmountRouter(
                  contact: (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
                  bankingAccount: bankingAccount,
                  isCJ: isCJ,
                ),
              )
              .then(
                (value) => getIt.get<IbanStore>().getAddressBook(),
              );
        }
      });
    }

    return;
  }

  sShowBasicModalBottomSheet(
    context: context,
    pinned: SBottomSheetHeader(
      name: intl.bankAccountsSelectPopupTitle,
    ),
    scrollable: true,
    children: [
      const SpaceH12(),
      ShowBankTransferSelect(
        bankingAccount: bankingAccount,
        isCJ: isCJ,
        isSendFlow: isSendFlow,
        currency: currency,
      ),
      const SpaceH42(),
    ],
  );
}

class ShowBankTransferSelect extends StatelessObserverWidget {
  const ShowBankTransferSelect({
    super.key,
    required this.bankingAccount,
    required this.isCJ,
    required this.isSendFlow,
    required this.currency,
  });

  final SimpleBankingAccount bankingAccount;
  final bool isCJ;
  final bool isSendFlow;
  final CurrencyModel? currency;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final store = getIt.get<IbanStore>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isCJ) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: colors.yellowLight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: SUserIcon(
                        color: colors.black,
                      ),
                    ),
                    const SpaceW14(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 88,
                      child: Text(
                        intl.bankAccountsSelectPopup,
                        style: sBodyText2Style,
                        maxLines: 15,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SpaceH16(),
        ],
        SPaddingH24(
          child: Text(
            isCJ ? intl.bankAccountsSelectPopupMyAccounts : intl.bankAccountsSelectPopupRecipients,
            style: sBodyText2Style.copyWith(
              color: colors.grey2,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts).length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return SEditable(
              leftIcon: const SizedBox(
                width: 24,
                height: 24,
                child: SAccountIcon(),
              ),
              rightIcon: Padding(
                padding: const EdgeInsets.only(top: 9.0),
                child: SIconButton(
                  onTap: () {
                    sAnalytics.eurWithdrawUserTapsOnButtonEdit(
                      isCJ: isCJ,
                      accountIban: bankingAccount.iban ?? '',
                      accountLabel: bankingAccount.label ?? '',
                    );

                    sAnalytics.eurWithdrawEditBankAccountWithSV(
                      isCJ: isCJ,
                      accountIban: bankingAccount.iban ?? '',
                      accountLabel: bankingAccount.label ?? '',
                    );

                    if (isCJ) {
                      sRouter
                          .push(
                        IbanAdressBookSimpleRoute(
                          contact: (isCJ
                              ? getIt.get<IbanStore>().simpleContacts
                              : getIt.get<IbanStore>().allContacts)[index],
                          bankingAccount: bankingAccount,
                        ),
                      )
                          .then((value) {
                        sAnalytics.eurWithdrawTapCloseEdit(
                          isCJ: true,
                          accountIban: bankingAccount.iban ?? '',
                          accountLabel: bankingAccount.label ?? '',
                        );
                      });
                    } else {
                      sRouter
                          .push(
                        IbanAdressBookUnlimitRoute(
                          contact: (isCJ
                              ? getIt.get<IbanStore>().simpleContacts
                              : getIt.get<IbanStore>().allContacts)[index],
                          bankingAccount: bankingAccount,
                        ),
                      )
                          .then((value) {
                        sAnalytics.eurWithdrawTapCloseEdit(
                          isCJ: false,
                          accountIban: bankingAccount.iban ?? '',
                          accountLabel: bankingAccount.label ?? '',
                        );
                      });
                    }
                  },
                  defaultIcon: const SEditIcon(),
                  pressedIcon: const SEditIcon(
                    color: Color(0xFFA8B0BA),
                  ),
                ),
              ),
              lable:
                  (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[index].name ?? '',
              supplement:
                  (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[index].iban ?? '',
              onCardTap: () {
                sAnalytics.eurWithdrawTapExistingAccount(
                  isCJ: isCJ,
                  accountIban: bankingAccount.iban ?? '',
                  accountLabel: bankingAccount.label ?? '',
                );

                if (isSendFlow) {
                  Navigator.of(context).pop();

                  if (currency != null) {
                    getIt<AppRouter>().push(
                      IbanSendAmountRouter(
                        isCJ: isCJ,
                        contact:
                            (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[index],
                        currency: currency,
                      ),
                    );
                  } else {
                    showChooseAssetToSend(
                      sRouter.navigatorKey.currentContext!,
                      contact:
                          (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[index],
                      isCJ: isCJ,
                    );
                  }
                } else {
                  getIt<AppRouter>()
                      .push(
                        IbanSendAmountRouter(
                          contact: (isCJ
                              ? getIt.get<IbanStore>().simpleContacts
                              : getIt.get<IbanStore>().allContacts)[index],
                          bankingAccount: bankingAccount,
                          isCJ: isCJ,
                        ),
                      )
                      .then(
                        (value) => store.getAddressBook(),
                      );
                }
              },
            );
          },
        ),
        SEditable(
          leftIcon: SizedBox(
            width: 24,
            height: 24,
            child: SPlusIcon(
              color: colors.blue,
            ),
          ),
          lable: isCJ ? intl.iban_add_bank_account : intl.address_book_add_recipient,
          supplement: intl.iban_local_euro_accounts_only,
          onCardTap: () {
            sAnalytics.eurWithdrawTapReceive(
              isCJ: isCJ,
              accountIban: bankingAccount.iban ?? '',
              accountLabel: bankingAccount.label ?? '',
            );

            sAnalytics.eurWithdrawAddReceiving(
              isCJ: isCJ,
              accountIban: bankingAccount.iban ?? '',
              accountLabel: bankingAccount.label ?? '',
            );

            if (isCJ) {
              sRouter
                  .push(
                IbanAdressBookSimpleRoute(
                  bankingAccount: bankingAccount,
                ),
              )
                  .then(
                (value) async {
                  if (value == null) {
                    return;
                  }
                  if (!(value as bool)) {
                    sAnalytics.eurWithdrawTapBackReceiving(
                      isCJ: isCJ,
                      accountIban: bankingAccount.iban ?? '',
                      accountLabel: bankingAccount.label ?? '',
                    );

                    return;
                  }

                  await getIt.get<IbanStore>().getAddressBook();

                  if (isSendFlow) {
                    Navigator.of(context).pop();

                    if (currency != null) {
                      await getIt<AppRouter>().push(
                        IbanSendAmountRouter(
                          isCJ: isCJ,
                          contact:
                              (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
                          currency: currency,
                        ),
                      );
                    } else {
                      showChooseAssetToSend(
                        sRouter.navigatorKey.currentContext!,
                        contact: (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
                        isCJ: isCJ,
                      );
                    }
                  } else {
                    await getIt<AppRouter>()
                        .push(
                          IbanSendAmountRouter(
                            contact:
                                (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
                            bankingAccount: bankingAccount,
                            isCJ: isCJ,
                          ),
                        )
                        .then(
                          (value) => getIt.get<IbanStore>().getAddressBook(),
                        )
                        .then((value) {
                      getIt.get<IbanStore>().getAddressBook();

                      sAnalytics.eurWithdrawTapBackReceiving(
                        isCJ: isCJ,
                        accountIban: bankingAccount.iban ?? '',
                        accountLabel: bankingAccount.label ?? '',
                      );
                    });
                  }
                },
              );
            } else {
              sRouter
                  .push(
                IbanAdressBookUnlimitRoute(
                  bankingAccount: bankingAccount,
                ),
              )
                  .then(
                (value) async {
                  if (value == null) {
                    return;
                  }
                  if (!(value as bool)) {
                    sAnalytics.eurWithdrawTapBackReceiving(
                      isCJ: isCJ,
                      accountIban: bankingAccount.iban ?? '',
                      accountLabel: bankingAccount.label ?? '',
                    );

                    return;
                  }

                  await getIt.get<IbanStore>().getAddressBook();

                  if (isSendFlow) {
                    Navigator.of(context).pop();

                    if (currency != null) {
                      await getIt<AppRouter>().push(
                        IbanSendAmountRouter(
                          isCJ: isCJ,
                          contact:
                              (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
                          currency: currency,
                        ),
                      );
                    } else {
                      showChooseAssetToSend(
                        sRouter.navigatorKey.currentContext!,
                        contact: (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
                        isCJ: isCJ,
                      );
                    }
                  } else {
                    await getIt<AppRouter>()
                        .push(
                      IbanSendAmountRouter(
                        contact: (isCJ ? getIt.get<IbanStore>().simpleContacts : getIt.get<IbanStore>().allContacts)[0],
                        bankingAccount: bankingAccount,
                        isCJ: isCJ,
                      ),
                    )
                        .then((value) {
                      getIt.get<IbanStore>().getAddressBook();

                      sAnalytics.eurWithdrawTapBackReceiving(
                        isCJ: isCJ,
                        accountIban: bankingAccount.iban ?? '',
                        accountLabel: bankingAccount.label ?? '',
                      );
                    });
                  }
                },
              );
            }
          },
        ),
      ],
    );
  }
}
