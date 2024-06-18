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
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/split_iban.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
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

@RoutePage(name: 'IbanSendConfirmRouter')
class IbanSendConfirm extends StatefulWidget {
  const IbanSendConfirm({
    super.key,
    required this.contact,
    required this.data,
    required this.previewRequest,
    required this.account,
    required this.isCJ,
  });

  final AddressBookContactModel contact;
  final BankingWithdrawalPreviewResponse data;
  final BankingWithdrawalPreviewModel previewRequest;
  final SimpleBankingAccount account;

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
      enteredAmount: widget.data.amount.toString(),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<IbanSendConfirmStore>(
      create: (context) => IbanSendConfirmStore()..init(widget.data),
      builder: (context, child) => IbanSendConfirmBody(
        contact: widget.contact,
        data: widget.data,
        previewRequest: widget.previewRequest,
        account: widget.account,
        isCJ: widget.isCJ,
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
  });

  final AddressBookContactModel contact;
  final BankingWithdrawalPreviewResponse data;
  final BankingWithdrawalPreviewModel previewRequest;
  final SimpleBankingAccount account;

  final bool isCJ;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final state = IbanSendConfirmStore.of(context);

    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

    final simpleFeeCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == (data.simpleFeeAsset ?? 'EUR')).first;

    return SPageFrameWithPadding(
      loaderText: intl.loader_please_wait,
      loading: state.loader,
      customLoader: WaitingScreen(
        onSkip: () {},
      ),
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
                    fromAssetIconUrl: eurCurrency.iconUrl,
                    fromAssetDescription: account.label ?? '',
                    fromAssetValue: volumeFormat(
                      symbol: eurCurrency.symbol,
                      accuracy: eurCurrency.accuracy,
                      decimal: data.amount ?? Decimal.zero,
                    ),
                    fromAssetCustomIcon: const BlueBankIconDeprecated(),
                    toAssetIconUrl: eurCurrency.iconUrl,
                    toAssetDescription: eurCurrency.description,
                    toAssetValue: volumeFormat(
                      decimal: data.sendAmount ?? Decimal.zero,
                      accuracy: eurCurrency.accuracy,
                      symbol: eurCurrency.symbol,
                    ),
                  ),
                  const SDivider(),
                  SActionConfirmText(
                    name: intl.iban_out_sent_to,
                    icon: isCJ ? const BlueBankIconDeprecated(size: 20) : const BlueBankUnlimitIcon(size: 20),
                    value: contact.name ?? '',
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_iban,
                    value: splitIban(data.iban ?? ''),
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_bic,
                    value: previewRequest.beneficiaryBankCode ?? '',
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_benificiary,
                    value: isCJ ? '${sUserInfo.firstName} ${sUserInfo.lastName}' : data.fullName ?? '',
                  ),
                  if (!isCJ) ...[
                    SActionConfirmText(
                      name: intl.iban_reference,
                      value: previewRequest.description ?? '',
                    ),
                  ],
                  const SpaceH18(),
                  PaymentFeeRowWidget(
                    fee: volumeFormat(
                      decimal: data.feeAmount ?? Decimal.zero,
                      accuracy: state.eurCurrency.accuracy,
                      symbol: state.eurCurrency.symbol,
                    ),
                  ),
                  const SpaceH18(),
                  ProcessingFeeRowWidget(
                    fee: volumeFormat(
                      decimal: data.simpleFeeAmount ?? Decimal.zero,
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
                      enteredAmount: data.amount.toString(),
                    );

                    sRouter.push(
                      PinScreenRoute(
                        union: const Change(),
                        isChangePhone: true,
                        onWrongPin: (String error) {
                          sAnalytics.errorWrongPin(
                            asset: 'EUR',
                            errorText: error,
                            sendMethod: AnalyticsSendMethods.bankAccount,
                          );
                        },
                        onChangePhone: (String newPin) {
                          sRouter.maybePop();

                          state.confirmIbanOut(
                            previewRequest,
                            data,
                            contact,
                            newPin,
                            account,
                            isCJ,
                          );
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
