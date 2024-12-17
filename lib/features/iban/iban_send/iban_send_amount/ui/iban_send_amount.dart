import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_amount/helpers/show_reference_sheet.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_amount/store/iban_send_amount_store.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
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
                        if (store.inputMode == WithdrawalInputMode.recepientGets) {
                          store.setInputMode(WithdrawalInputMode.youSend);
                        }
                      },
                    ),
                    if (currency != null)
                      STagButton(
                        lable: intl.withdrawal_recipient_gets,
                        state: store.inputMode == WithdrawalInputMode.recepientGets
                            ? TagButtonState.selected
                            : TagButtonState.defaultt,
                        onTap: () {
                          if (store.inputMode == WithdrawalInputMode.youSend) {
                            store.setInputMode(WithdrawalInputMode.recepientGets);
                          }
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
            errorText: store.withAmmountInputError.isActive ? error : null,
            showMaxButton: true,
            onMaxTap: store.onSendAll,
            loadingMaxButton: store.loadingMaxButton && store.onMaxPressed,
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
            showSwopButton: false,
            onSwap: () {},
          ),
          const Spacer(),
          SuggestionButton(
            subTitle: intl.withdrawOptions_sendTo,
            trailing: shortIbanFormTwo(store.contact?.iban ?? ''),
            title: store.contact?.name ?? '',
            icon: Assets.svg.other.medium.bankAccount.simpleSvg(),
            onTap: () {},
            showArrow: false,
          ),
          const SpaceH8(),
          SNumericKeyboard(
            onKeyPressed: (value) {
              store.updateAmount(value);
            },
            button: SButton.black(
              text: intl.withdraw_continue,
              callback: store.withValid
                  ? () async {
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
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
