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
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/non_indices_with_balance_from.dart';
import 'package:jetwallet/utils/helpers/split_iban.dart';
import 'package:jetwallet/utils/helpers/widget_size_from.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_preview_withdrawal_model.dart';

@RoutePage(name: 'IbanSendConfirmRouter')
class IbanSendConfirm extends StatelessWidget {
  const IbanSendConfirm({
    super.key,
    required this.contact,
    required this.data,
  });

  final AddressBookContactModel contact;
  final IbanPreviewWithdrawalModel data;

  @override
  Widget build(BuildContext context) {
    return Provider<IbanSendConfirmStore>(
      create: (context) => IbanSendConfirmStore()..init(data),
      builder: (context, child) => IbanSendConfirmBody(
        contact: contact,
        data: data,
      ),
    );
  }
}

class IbanSendConfirmBody extends StatelessObserverWidget {
  const IbanSendConfirmBody({
    super.key,
    required this.contact,
    required this.data,
  });

  final AddressBookContactModel contact;
  final IbanPreviewWithdrawalModel data;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final state = IbanSendConfirmStore.of(context);

    final eurCurrency = nonIndicesWithBalanceFrom(
      sSignalRModules.currenciesList,
    ).where((element) => element.symbol == 'EUR').first;

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
                    fromAssetDescription: contact.name ?? '',
                    fromAssetValue: volumeFormat(
                      symbol: eurCurrency.symbol,
                      accuracy: eurCurrency.accuracy,
                      decimal: data.amount ?? Decimal.zero,
                    ),
                    fromAssetCustomIcon: const BlueBankIcon(),
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
                    name: intl.iban_out_label,
                    icon: const BlueBankIcon(size: 20),
                    value: contact.name ?? '',
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_iban,
                    value: splitIban(data.iban ?? ''),
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_bic,
                    value: data.bic ?? '',
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_benificiary,
                    value: '${sUserInfo.firstName} ${sUserInfo.lastName}',
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_payment_fee,
                    value: volumeFormat(
                      decimal: data.feeAmount ?? Decimal.zero,
                      accuracy: state.eurCurrency.accuracy,
                      symbol: state.eurCurrency.symbol,
                    ),
                    maxValueWidth: 140,
                  ),
                  SActionConfirmText(
                    name: intl.iban_out_fee,
                    value: volumeFormat(
                      decimal: data.feeAmount ?? Decimal.zero,
                      accuracy: state.eurCurrency.accuracy,
                      symbol: state.eurCurrency.symbol,
                    ),
                    maxValueWidth: 140,
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
                    sAnalytics.tapOnTheButtonConfirmSendIban(
                      asset: 'EUR',
                      methodType: '2',
                      sendAmount: data.amount.toString(),
                    );

                    sAnalytics.ibanConfirmWithPINScreenView(
                      asset: 'EUR',
                      methodType: '2',
                      sendAmount: data.amount.toString(),
                    );

                    sRouter.push(
                      PinScreenRoute(
                        union: const Change(),
                        isChangePhone: true,
                        onWrongPin: (String error) {
                          sAnalytics.errorWrongPinSend(
                            asset: 'EUR',
                            methodType: '2',
                            sendAmount: data.amount.toString(),
                            errorCode: error,
                          );
                          sAnalytics.errorWrongPin(
                            asset: 'EUR',
                            errorText: error,
                            sendMethod: AnalyticsSendMethods.bankAccount,
                          );
                        },
                        onChangePhone: (String newPin) {
                          sRouter.pop();
                          state.confirmIbanOut(
                            data,
                            contact,
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
