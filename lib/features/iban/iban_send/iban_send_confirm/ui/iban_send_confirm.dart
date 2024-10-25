import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/iban/iban_send/iban_send_confirm/store/iban_send_confirm_store.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/split_iban.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_response.dart';
import 'package:simple_networking/modules/wallet_api/models/sell/get_crypto_sell_response_model.dart';

@RoutePage(name: 'IbanSendConfirmRouter')
class IbanSendConfirm extends StatefulWidget {
  const IbanSendConfirm({
    super.key,
    required this.contact,
    required this.data,
    required this.previewRequest,
    required this.account,
    required this.isCJ,
    required this.cryptoSell,
  });

  final AddressBookContactModel contact;
  final BankingWithdrawalPreviewResponse? data;
  final BankingWithdrawalPreviewModel? previewRequest;
  final SimpleBankingAccount account;
  final GetCryptoSellResponseModel? cryptoSell;

  final bool isCJ;

  @override
  State<IbanSendConfirm> createState() => _IbanSendConfirmState();
}

class _IbanSendConfirmState extends State<IbanSendConfirm> {
  @override
  void initState() {
    sAnalytics.eurWithdrawWithdrawOrderSummarySV(
      isCJ: widget.isCJ,
      accountIban: widget.account.iban ?? '',
      accountLabel: widget.account.label ?? '',
      eurAccType: widget.contact.iban ?? '',
      eurAccLabel: widget.contact.name ?? '',
      enteredAmount:
          widget.cryptoSell != null ? widget.cryptoSell!.paymentAmount.toString() : widget.data!.amount.toString(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<IbanSendConfirmStore>(
      create: (context) => IbanSendConfirmStore()..init(widget.data, widget.cryptoSell),
      builder: (context, child) => IbanSendConfirmBody(
        contact: widget.contact,
        data: widget.data,
        previewRequest: widget.previewRequest,
        account: widget.account,
        isCJ: widget.isCJ,
        cryptoSell: widget.cryptoSell,
      ),
    );
  }
}

class IbanSendConfirmBody extends StatelessObserverWidget {
  const IbanSendConfirmBody({
    super.key,
    required this.contact,
    required this.data,
    required this.previewRequest,
    required this.account,
    required this.isCJ,
    required this.cryptoSell,
  });

  final AddressBookContactModel contact;
  final BankingWithdrawalPreviewResponse? data;
  final BankingWithdrawalPreviewModel? previewRequest;
  final SimpleBankingAccount account;
  final GetCryptoSellResponseModel? cryptoSell;

  final bool isCJ;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final state = IbanSendConfirmStore.of(context);

    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    final currency = data != null
        ? eurCurrency
        : nonIndicesWithBalanceFrom(
            sSignalRModules.currenciesList,
          ).where((element) => element.symbol == cryptoSell!.paymentAssetSymbol).first;

    CurrencyModel simpleFeeCurrency;
    if (data != null) {
      simpleFeeCurrency = nonIndicesWithBalanceFrom(
        sSignalRModules.currenciesList,
      ).where((element) => element.symbol == (data!.simpleFeeAsset ?? 'EUR')).first;
    } else {
      simpleFeeCurrency = nonIndicesWithBalanceFrom(
        sSignalRModules.currenciesList,
      ).where((element) => element.symbol == (cryptoSell!.tradeFeeAsset)).first;
    }

    final buyCurrency = data != null
        ? eurCurrency
        : nonIndicesWithBalanceFrom(
            sSignalRModules.currenciesList,
          ).where((element) => element.symbol == (cryptoSell!.buyAssetSymbol)).first;

    return SPageFrameWithPadding(
      loaderText: intl.loader_please_wait,
      loading: state.loader,
      customLoader: const WaitingScreen(),
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        subTitle: intl.withdraw,
        subTitleStyle: sBodyText2Style.copyWith(
          color: colors.grey1,
        ),
      ),
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(
              bottom: widgetSizeFrom(deviceSize) == SWidgetSize.small ? 310.0 : 260.0,
            ),
            children: [
              Column(
                children: [
                  deviceSize.when(
                    small: () => const SpaceH8(),
                    medium: () => const SpaceH3(),
                  ),
                  WhatToWhatConvertWidget(
                    isLoading: false,
                    fromAssetIconUrl: cryptoSell != null ? currency.iconUrl : currency.iconUrl,
                    fromAssetDescription: cryptoSell != null ? currency.description : account.label ?? '',
                    fromAssetValue:
                        (cryptoSell != null ? cryptoSell!.paymentAmount : data!.amount ?? Decimal.zero).toFormatCount(
                      symbol: currency.symbol,
                      accuracy: currency.accuracy,
                    ),
                    fromAssetCustomIcon: cryptoSell != null ? null : const BlueBankIconDeprecated(),
                    toAssetIconUrl: currency.iconUrl,
                    toAssetDescription: cryptoSell != null ? contact.name ?? '' : currency.description,
                    toAssetValue:
                        (cryptoSell != null ? cryptoSell!.buyAmount : data!.sendAmount ?? Decimal.zero).toFormatCount(
                      accuracy: cryptoSell != null ? buyCurrency.accuracy : currency.accuracy,
                      symbol: cryptoSell != null ? buyCurrency.symbol : currency.symbol,
                    ),
                    toAssetCustomIcon: cryptoSell != null ? const BlueBankIconDeprecated() : null,
                  ),
                  const SDivider(),
                  SActionConfirmText(
                    name: intl.iban_out_sent_to,
                    icon: isCJ ? const BlueBankIconDeprecated(size: 20) : const BlueBankUnlimitIcon(size: 20),
                    value: contact.name ?? '',
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_iban,
                    value: splitIban(cryptoSell != null ? contact.iban ?? '' : data!.iban ?? ''),
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_bic,
                    value: cryptoSell != null ? contact.bic ?? '' : previewRequest!.beneficiaryBankCode ?? '',
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_benificiary,
                    value: isCJ
                        ? '${sUserInfo.firstName} ${sUserInfo.lastName}'
                        : cryptoSell != null
                            ? contact.name ?? ''
                            : data!.fullName ?? '',
                  ),
                  if (!isCJ) ...[
                    SActionConfirmText(
                      name: intl.iban_reference,
                      value: previewRequest!.description ?? '',
                    ),
                  ],
                  const SpaceH18(),
                  PaymentFeeRowWidget(
                    fee: (cryptoSell != null ? cryptoSell!.paymentFeeInPaymentAsset : data!.feeAmount ?? Decimal.zero)
                        .toFormatCount(
                      accuracy: state.eurCurrency.accuracy,
                      symbol: state.eurCurrency.symbol,
                    ),
                  ),
                  const SpaceH18(),
                  ProcessingFeeRowWidget(
                    fee: (cryptoSell != null ? cryptoSell!.tradeFeeAmount : data!.simpleFeeAmount ?? Decimal.zero)
                        .toFormatCount(
                      accuracy: simpleFeeCurrency.accuracy,
                      symbol: simpleFeeCurrency.symbol,
                    ),
                  ),
                  const SpaceH17(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          intl.iban_out_descr_1,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          style: sCaptionTextStyle.copyWith(
                            color: colors.grey3,
                          ),
                        ),
                        Text(
                          intl.iban_out_descr_2,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          style: sCaptionTextStyle.copyWith(
                            color: colors.grey3,
                          ),
                        ),
                        Text(
                          intl.iban_out_descr_3,
                          maxLines: 3,
                          textAlign: TextAlign.start,
                          style: sCaptionTextStyle.copyWith(
                            color: colors.grey3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceH16(),
                  const SDivider(),
                ],
              ),
            ],
          ),
          SFloatingButtonFrame(
            hidePadding: true,
            button: Column(
              children: [
                const SpaceH24(),
                SPrimaryButton2(
                  active: true,
                  name: intl.previewBuyWithAsset_confirm,
                  onTap: () {
                    sAnalytics.eurWithdrawTapConfirmOrderSummary(
                      isCJ: isCJ,
                      accountIban: account.iban ?? '',
                      accountLabel: account.label ?? '',
                      eurAccType: contact.iban ?? '',
                      eurAccLabel: contact.name ?? '',
                      enteredAmount: cryptoSell != null ? cryptoSell!.buyAmount.toString() : data!.amount.toString(),
                    );

                    sRouter.push(
                      PinScreenRoute(
                        union: const Change(),
                        isChangePhone: true,
                        onWrongPin: (String error) {},
                        onChangePhone: (String newPin) {
                          sRouter.maybePop();

                          if (cryptoSell == null) {
                            state.confirmIbanOut(
                              previewRequest!,
                              data!,
                              contact,
                              newPin,
                              account,
                              isCJ,
                            );
                          } else {
                            state.confirmCryptoIbanOut(
                              previewRequest!,
                              cryptoSell!,
                              contact,
                              newPin,
                              account,
                              isCJ,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
