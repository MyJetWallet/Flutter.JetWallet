import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_amount/helpers/show_reference_sheet.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_amount/store/iban_send_amount_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

@RoutePage(name: 'IbanSendAmountRouter')
class IbanSendAmount extends StatelessWidget {
  const IbanSendAmount({
    super.key,
    required this.contact,
    required this.bankingAccount,
    required this.isCJ,
  });

  final AddressBookContactModel contact;
  final SimpleBankingAccount bankingAccount;
  final bool isCJ;

  @override
  Widget build(BuildContext context) {
    return Provider<IbanSendAmountStore>(
      create: (context) => IbanSendAmountStore()..init(contact, bankingAccount, isCJ),
      builder: (context, child) => IbanSendAmountBody(
        contact: contact,
        bankingAccount: bankingAccount,
        isCJ: isCJ,
      ),
    );
  }
}

class IbanSendAmountBody extends StatelessObserverWidget {
  const IbanSendAmountBody({
    super.key,
    required this.contact,
    required this.bankingAccount,
    required this.isCJ,
  });

  final AddressBookContactModel contact;
  final SimpleBankingAccount bankingAccount;
  final bool isCJ;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final store = IbanSendAmountStore.of(context);

    return SPageFrame(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.withdraw,
          subTitle: '${intl.withdrawalAmount_available}: ${volumeFormat(
            decimal: store.availableCurrency,
            accuracy: store.eurCurrency.accuracy,
            symbol: store.eurCurrency.symbol,
          )}',
          subTitleStyle: sSubtitle3Style.copyWith(
            color: colors.grey2,
          ),
          onBackButtonTap: () {
            sAnalytics.eurWithdrawBackAmountSV(
              isCJ: isCJ,
              accountIban: bankingAccount.iban ?? '',
              accountLabel: bankingAccount.label ?? '',
              eurAccType: contact.iban ?? '',
              eurAccLabel: contact.name ?? '',
            );

            Navigator.pop(context);
          },
        ),
      ),
      child: Column(
        children: [
          deviceSize.when(
            small: () => const SizedBox(),
            medium: () => const Spacer(),
          ),
          Column(
            children: [
              Baseline(
                baseline: 45,
                baselineType: TextBaseline.alphabetic,
                child: SActionPriceField(
                  widgetSize: widgetSizeFrom(deviceSize),
                  price: formatCurrencyStringAmount(
                    value: store.withAmount,
                    symbol: store.eurCurrency.symbol,
                  ),
                  helper: '',
                  error: store.withAmmountInputError == InputError.limitError
                      ? store.limitError
                      : store.withAmmountInputError.value(),
                  //isErrorActive: store.withAmmountInputError.isActive,
                  isErrorActive: false,
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
              ),
            ],
          ),
          const Spacer(),
          if (!store.withAmmountInputError.isActive) ...[
            if (store.showAllWithdraw)
              STransparentInkWell(
                onTap: () {
                  store.updateAmount(store.availableCurrency.toString());
                },
                child: Text(
                  '${intl.withdrawAll} ${volumeFormat(
                    decimal: store.availableCurrency,
                    accuracy: store.eurCurrency.accuracy,
                    symbol: store.eurCurrency.symbol,
                  )}',
                  style: sBodyText1Style.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.blue,
                  ),
                ),
              ),
          ] else ...[
            Text(
              store.withAmmountInputError == InputError.limitError
                  ? store.limitError
                  : store.withAmmountInputError.value(),
              style: sBodyText2Style.copyWith(
                color: colors.red,
              ),
            ),
          ],
          const SpaceH20(),
          SPaymentSelectAsset(
            widgetSize: widgetSizeFrom(deviceSize),
            icon: SAccountIcon(
              color: colors.black,
            ),
            name: store.contact?.name ?? '',
            description: store.contact?.iban ?? '',
          ),
          deviceSize.when(
            small: () => const Spacer(),
            medium: () => const SpaceH20(),
          ),
          SNumericKeyboardAmount(
            widgetSize: widgetSizeFrom(deviceSize),
            onKeyPressed: (value) {
              store.updateAmount(value);
            },
            buttonType: SButtonType.primary2,
            submitButtonActive: store.withValid,
            submitButtonName: intl.addCircleCard_continue,
            onSubmitPressed: () {
              sAnalytics.eurWithdrawContinueFromAmoountB(
                isCJ: isCJ,
                accountIban: bankingAccount.iban ?? '',
                accountLabel: bankingAccount.label ?? '',
                eurAccType: contact.iban ?? '',
                eurAccLabel: contact.name ?? '',
                enteredAmount: store.withAmount,
              );

              if (isCJ) {
                store.loadPreview(null, isCJ);
              } else {
                sAnalytics.eurWithdrawReferenceSV(
                  eurAccountType: isCJ ? 'CJ' : 'Unlimit',
                  accountIban: bankingAccount.iban ?? '',
                  accountLabel: bankingAccount.label ?? '',
                  eurAccType: contact.iban ?? '',
                  eurAccLabel: contact.name ?? '',
                  enteredAmount: store.withAmount,
                );

                showReferenceSheet(
                  context,
                  (description) {
                    sAnalytics.eurWithdrawContinueReferecenceButton(
                      eurAccountType: isCJ ? 'CJ' : 'Unlimit',
                      accountIban: bankingAccount.iban ?? '',
                      accountLabel: bankingAccount.label ?? '',
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
    );
  }
}
