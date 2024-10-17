import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/amount_screen.dart/suggestion_button_widget.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_amount/helpers/show_reference_sheet.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_amount/store/iban_send_amount_store.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/network_icon_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

@RoutePage(name: 'IbanSendAmountRouter')
class IbanSendAmount extends StatelessWidget {
  const IbanSendAmount({
    super.key,
    required this.contact,
    required this.isCJ,
    this.bankingAccount,
    this.currency,
  });

  final AddressBookContactModel contact;
  final bool isCJ;
  final SimpleBankingAccount? bankingAccount;
  final CurrencyModel? currency;

  @override
  Widget build(BuildContext context) {
    return Provider<IbanSendAmountStore>(
      create: (context) => IbanSendAmountStore()
        ..init(
          value: contact,
          isCJ: isCJ,
          bankingAccount: bankingAccount,
          currencyModel: currency,
        ),
      builder: (context, child) => IbanSendAmountBody(
        isCJ: isCJ,
        contact: contact,
        bankingAccount: bankingAccount,
        currency: currency,
      ),
    );
  }
}

class IbanSendAmountBody extends StatelessObserverWidget {
  const IbanSendAmountBody({
    super.key,
    required this.isCJ,
    required this.contact,
    this.bankingAccount,
    this.currency,
  });

  final bool isCJ;
  final AddressBookContactModel contact;
  final SimpleBankingAccount? bankingAccount;
  final CurrencyModel? currency;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = SColorsLight();

    final store = IbanSendAmountStore.of(context);

    final String error;

    switch (store.withAmmountInputError) {
      case InputError.enterHigherAmount:
        error = intl.withrawal_amount_error_entered_amount;
      case InputError.limitError:
        error = store.limitError;
      default:
        error = store.withAmmountInputError.value();
    }

    return SPageFrame(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      header: GlobalBasicAppBar(
        title: '''${intl.withdrawal_send_verb} ${currency != null ? currency!.description : intl.iban_euro}''',
        hasRightIcon: false,
        subtitle:
            '${intl.withdrawalAmount_available}: ${getIt<AppStore>().isBalanceHide ? '**** ${currency != null ? currency!.symbol : store.eurCurrency.symbol}' : (store.availableAmount < Decimal.zero ? Decimal.zero : store.availableAmount).toFormatCount(
                accuracy: currency != null ? currency!.accuracy : store.eurCurrency.accuracy,
                symbol: currency != null ? currency!.symbol : store.eurCurrency.symbol,
              )}',
        onLeftIconTap: () {
          sAnalytics.eurWithdrawBackAmountSV(
            isCJ: isCJ,
            accountIban: bankingAccount?.iban ?? '',
            accountLabel: bankingAccount?.label ?? '',
            eurAccType: contact.iban ?? '',
            eurAccLabel: contact.name ?? '',
          );

          Navigator.pop(context);
        },
      ),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 8,
                  children: [
                    STagButton(
                      lable: intl.withdrawal_you_send,
                      state: store.inputMode == WithdrawalInputMode.youSend
                          ? TagButtonState.selected
                          : TagButtonState.defaultt,
                      onTap: () {
                        store.setInputMode(WithdrawalInputMode.youSend);
                      },
                    ),
                    STagButton(
                      lable: intl.withdrawal_recipient_gets,
                      state: store.inputMode == WithdrawalInputMode.recepientGets
                          ? TagButtonState.selected
                          : TagButtonState.defaultt,
                      onTap: () {
                        store.setInputMode(WithdrawalInputMode.recepientGets);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          SNumericLargeInput(
            primaryAmount: formatCurrencyStringAmount(
              value: store.primaryAmount,
            ),
            primarySymbol: store.primarySymbol,
            secondaryAmount: store.mainCurrency.symbol != 'EUR'
                ? '${intl.earn_est} ${Decimal.parse(store.secondaryAmount).toFormatSum(
                    accuracy: store.secondaryAccuracy,
                  )}'
                : '',
            secondarySymbol: store.mainCurrency.symbol != 'EUR' ? store.secondarySymbol : '',
            showSwopButton: store.mainCurrency.symbol != 'EUR',
            onSwap: store.onSwap,
            errorText: store.withAmmountInputError.isActive ? error : null,
            showMaxButton: true,
            onMaxTap: store.onSendAll,
            pasteLabel: intl.paste,
            onPaste: () async {
              final data = await Clipboard.getData('text/plain');
              if (data?.text != null) {
                final n = double.tryParse(data!.text!);
                if (n != null) {
                  store.pasteAmount(n.toString().trim());
                }
              }
            },
          ),
          const Spacer(),
          SuggestionButtonWidget(
            subTitle: intl.withdrawOptions_sendTo,
            trailing: store.contact?.iban ?? '',
            title: store.contact?.name ?? '',
            icon: Assets.svg.other.medium.bankAccount.simpleSvg(),
            onTap: () {},
            showArrow: false,
          ),
          const SpaceH12(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(4),
                  decoration: ShapeDecoration(
                    color: colors.gray2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: store.inputMode == WithdrawalInputMode.youSend
                      ? Assets.svg.medium.remove.simpleSvg()
                      : Assets.svg.medium.add.simpleSvg(),
                ),
                const SpaceW12(),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: (store.feeAmount + store.simpleFeeAmount).toFormatCount(
                          symbol: store.mainCurrency.symbol,
                          accuracy: store.mainCurrency.accuracy,
                        ),
                        style: STStyles.body2Semibold,
                      ),
                      TextSpan(
                        text: ' ${intl.buy_confirmation_processing_fee}',
                        style: STStyles.body2Semibold.copyWith(
                          color: colors.gray10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpaceH8(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36),
            child: Row(
              children: [
                NetworkIconWidget(
                  width: 20,
                  height: 20,
                  store.mainCurrency.iconUrl,
                ),
                const SpaceW12(),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: store.inputMode == WithdrawalInputMode.youSend
                            ? store.recepientGetsAmount.toFormatCount(
                                symbol: store.mainCurrency.symbol,
                                accuracy: store.mainCurrency.accuracy,
                              )
                            : store.youSendAmount.toFormatCount(
                                symbol: store.mainCurrency.symbol,
                                accuracy: store.mainCurrency.accuracy,
                              ),
                        style: STStyles.body2Semibold,
                      ),
                      TextSpan(
                        text:
                            ' ${store.inputMode == WithdrawalInputMode.youSend ? intl.withdrawal_recipient_gets : intl.withdrawal_you_send}',
                        style: STStyles.body2Semibold.copyWith(
                          color: colors.gray10,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SpaceH8(),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            onKeyPressed: (value) {
              store.updateAmount(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: store.withValid,
            submitButtonName: intl.withdraw_continue,
            onSubmitPressed: () async {
              sAnalytics.eurWithdrawContinueFromAmoountB(
                isCJ: isCJ,
                accountIban: bankingAccount?.iban ?? '',
                accountLabel: bankingAccount?.label ?? '',
                eurAccType: contact.iban ?? '',
                eurAccLabel: contact.name ?? '',
                enteredAmount: store.withAmount,
              );

              if (isCJ) {
                await store.loadPreview(null, isCJ);
              } else {
                sAnalytics.eurWithdrawReferenceSV(
                  isCJ: isCJ,
                  accountIban: bankingAccount?.iban ?? '',
                  accountLabel: bankingAccount?.label ?? '',
                  eurAccType: contact.iban ?? '',
                  eurAccLabel: contact.name ?? '',
                  enteredAmount: store.withAmount,
                );

                showReferenceSheet(
                  context,
                  (description) {
                    sAnalytics.eurWithdrawContinueReferecenceButton(
                      isCJ: isCJ,
                      accountIban: bankingAccount?.iban ?? '',
                      accountLabel: bankingAccount?.label ?? '',
                      eurAccType: contact.iban ?? '',
                      eurAccLabel: contact.name ?? '',
                      enteredAmount: store.withAmount,
                      referenceText: description,
                    );

                    store.loadPreview(description, isCJ);
                  },
                );
              }
            },
          ),
        ],
      ),
      // child: Column(
      //   children: [
      //     deviceSize.when(
      //       small: () => const SizedBox(),
      //       medium: () => const Spacer(),
      //     ),
      //     Column(
      //       children: [
      //         Baseline(
      //           baseline: 45,
      //           baselineType: TextBaseline.alphabetic,
      //           child: SActionPriceField(
      //             widgetSize: widgetSizeFrom(deviceSize),
      //             price: formatCurrencyStringAmount(
      //               value: store.withAmount,
      //               symbol: store.eurCurrency.symbol,
      //             ),
      //             helper: '',
      //             error: store.withAmmountInputError == InputError.limitError
      //                 ? store.limitError
      //                 : store.withAmmountInputError.value(),
      //             //isErrorActive: store.withAmmountInputError.isActive,
      //             isErrorActive: false,
      //             pasteLabel: intl.paste,
      //             onPaste: () async {
      //               final data = await Clipboard.getData('text/plain');
      //               if (data?.text != null) {
      //                 final n = double.tryParse(data!.text!);
      //                 if (n != null) {
      //                   store.pasteAmount(n.toString().trim());
      //                 }
      //               }
      //             },
      //           ),
      //         ),
      //       ],
      //     ),
      //     const Spacer(),
      //     if (!store.withAmmountInputError.isActive) ...[
      //       if (store.showAllWithdraw)
      //         STransparentInkWell(
      //           onTap: () {
      //             store.updateAmount(store.availableCurrency.toString());
      //           },
      //           child: Text(
      //             '${intl.withdrawAll} ${store.availableCurrency.toFormatCount(
      //               accuracy: store.eurCurrency.accuracy,
      //               symbol: store.eurCurrency.symbol,
      //             )}',
      //             style: sBodyText1Style.copyWith(
      //               fontWeight: FontWeight.bold,
      //               color: colors.blue,
      //             ),
      //           ),
      //         ),
      //     ] else ...[
      //       Text(
      //         store.withAmmountInputError == InputError.limitError
      //             ? store.limitError
      //             : store.withAmmountInputError.value(),
      //         style: sBodyText2Style.copyWith(
      //           color: colors.red,
      //         ),
      //       ),
      //     ],
      //     const SpaceH20(),
      //     SPaymentSelectAsset(
      //       widgetSize: widgetSizeFrom(deviceSize),
      //       icon: SAccountIcon(
      //         color: colors.black,
      //       ),
      //       name: store.contact?.name ?? '',
      //       description: store.contact?.iban ?? '',
      //     ),
      //     deviceSize.when(
      //       small: () => const Spacer(),
      //       medium: () => const SpaceH20(),
      //     ),
      //     SNumericKeyboardAmount(
      //       widgetSize: widgetSizeFrom(deviceSize),
      //       onKeyPressed: (value) {
      //         store.updateAmount(value);
      //       },
      //       buttonType: SButtonType.primary2,
      //       submitButtonActive: store.withValid,
      //       submitButtonName: intl.addCircleCard_continue,
      //       onSubmitPressed: () {
      //         sAnalytics.eurWithdrawContinueFromAmoountB(
      //           isCJ: isCJ,
      //           accountIban: bankingAccount?.iban ?? '',
      //           accountLabel: bankingAccount?.label ?? '',
      //           eurAccType: contact.iban ?? '',
      //           eurAccLabel: contact.name ?? '',
      //           enteredAmount: store.withAmount,
      //         );
      //
      //         if (isCJ) {
      //           store.loadPreview(null, isCJ);
      //         } else {
      //           sAnalytics.eurWithdrawReferenceSV(
      //             isCJ: isCJ,
      //             accountIban: bankingAccount?.iban ?? '',
      //             accountLabel: bankingAccount?.label ?? '',
      //             eurAccType: contact.iban ?? '',
      //             eurAccLabel: contact.name ?? '',
      //             enteredAmount: store.withAmount,
      //           );
      //
      //           showReferenceSheet(
      //             context,
      //             (description) {
      //               sAnalytics.eurWithdrawContinueReferecenceButton(
      //                 isCJ: isCJ,
      //                 accountIban: bankingAccount?.iban ?? '',
      //                 accountLabel: bankingAccount?.label ?? '',
      //                 eurAccType: contact.iban ?? '',
      //                 eurAccLabel: contact.name ?? '',
      //                 enteredAmount: store.withAmount,
      //                 referenceText: description,
      //               );
      //
      //               store.loadPreview(description, isCJ);
      //             },
      //           );
      //         }
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}
