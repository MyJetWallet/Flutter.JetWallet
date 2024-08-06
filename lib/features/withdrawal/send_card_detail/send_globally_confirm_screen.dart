import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/withdrawal/send_card_detail/store/send_globally_confirm_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_card_response.dart';

import '../../pin_screen/model/pin_flow_union.dart';

@RoutePage(name: 'SendGloballyConfirmRouter')
class SendGloballyConfirmScreen extends StatelessWidget {
  const SendGloballyConfirmScreen({
    super.key,
    required this.data,
    required this.method,
  });

  final SendToBankCardResponse data;
  final GlobalSendMethodsModelMethods method;

  @override
  Widget build(BuildContext context) {
    return Provider<SendGloballyConfirmStore>(
      create: (context) => SendGloballyConfirmStore()..init(data, method),
      builder: (context, child) => SendGloballyConfirmScreenBody(
        data: data,
        method: method,
      ),
    );
  }
}

class SendGloballyConfirmScreenBody extends StatelessObserverWidget {
  const SendGloballyConfirmScreenBody({
    super.key,
    required this.data,
    required this.method,
  });

  final SendToBankCardResponse data;
  final GlobalSendMethodsModelMethods method;

  @override
  Widget build(BuildContext context) {
    final deviceSize = sDeviceSize;
    final colors = sKit.colors;

    final state = SendGloballyConfirmStore.of(context);

    final receiveAsset = currencyFrom(
      sSignalRModules.currenciesWithHiddenList,
      data.receiveAsset!,
    );

    return SPageFrameWithPadding(
      loading: state.loader,
      loaderText: intl.register_pleaseWait,
      header: SSmallHeader(
        title: intl.previewBuy_orderSummary,
        subTitle: intl.send,
        subTitleStyle: sSubtitle3Style.copyWith(
          color: colors.grey2,
        ),
      ),
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              bottom: 160,
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
                    fromAssetIconUrl: state.sendCurrency!.iconUrl,
                    fromAssetDescription: state.sendCurrency!.symbol,
                    fromAssetValue: (data.amount ?? Decimal.zero).toFormatCount(
                      symbol: state.sendCurrency!.symbol,
                      accuracy: state.sendCurrency!.accuracy,
                    ),
                    toAssetIconUrl: receiveAsset.iconUrl,
                    toAssetDescription: receiveAsset.symbol,
                    toAssetValue: (data.estimatedReceiveAmount ?? Decimal.zero).toFormatSum(
                      accuracy: receiveAsset.accuracy,
                      symbol: receiveAsset.symbol,
                    ),
                  ),
                  const SDivider(),
                  const SpaceH16(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: STableHeader(
                      needHorizontalPadding: false,
                      title: intl.global_send_receiver_details,
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.receiverDetails.length,
                    itemBuilder: (context, index) {
                      return TwoColumnCell(
                        label: state.receiverDetails[index].info.fieldName ?? '',
                        value: state.receiverDetails[index].info.fieldId == FieldInfoId.cardNumber
                            ? getCardTypeMask(
                                state.receiverDetails[index].value,
                              )
                            : state.receiverDetails[index].value,
                        needHorizontalPadding: false,
                      );
                    },
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: STableHeader(
                      needHorizontalPadding: false,
                      title: intl.global_send_payment_details,
                    ),
                  ),
                  TwoColumnCell(
                    label: intl.send_globally_date,
                    value: DateFormat('dd.MM.y, HH:mm').format(DateTime.now()),
                    needHorizontalPadding: false,
                  ),
                  TwoColumnCell(
                    label: intl.global_send_payment_method_title,
                    value: method.name,
                    needHorizontalPadding: false,
                  ),
                  TwoColumnCell(
                    label: intl.send_globally_con_rate,
                    value:
                        '''${state.sendCurrency!.type == AssetType.crypto ? "1 ${state.sendCurrency!.symbol}" : "${state.sendCurrency!.prefixSymbol} 1"} = ${data.estimatedPrice?.toFormatPrice(prefix: receiveAsset.prefixSymbol)}''',
                    needHorizontalPadding: false,
                  ),
                  TwoColumnCell(
                    label: intl.global_send_history_sent,
                    value: ((data.amount ?? Decimal.zero) - (data.feeAmount ?? Decimal.zero)).toFormatCount(
                      accuracy: state.sendCurrency!.accuracy,
                      symbol: state.sendCurrency!.symbol,
                    ),
                    needHorizontalPadding: false,
                  ),
                  ProcessingFeeRowWidget(
                    fee: (data.feeAmount ?? Decimal.zero).toFormatCount(
                      accuracy: state.sendCurrency!.accuracy,
                      symbol: state.sendCurrency!.symbol,
                    ),
                    onTabListener: () {},
                    onBotomSheetClose: (_) {},
                    needPadding: true,
                  ),
                  const SpaceH17(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      intl.send_globally_transfer_info,
                      maxLines: 3,
                      textAlign: TextAlign.start,
                      style: sCaptionTextStyle.copyWith(
                        color: colors.grey3,
                      ),
                    ),
                  ),
                  const SpaceH15(),
                  const SDivider(),
                  const SpaceH20(),
                ],
              ),
            ],
          ),
          SFloatingButtonFrame(
            hidePadding: true,
            button: Column(
              children: [
                deviceSize.when(
                  small: () {
                    return Column(
                      children: [
                        const SDivider(),
                        SActionConfirmText(
                          name: intl.global_send_total_pay,
                          contentLoading: state.loader.loading,
                          valueColor: colors.blue,
                          value: (data.amount ?? Decimal.zero).toFormatCount(
                            accuracy: state.sendCurrency!.accuracy,
                            symbol: state.sendCurrency!.symbol,
                          ),
                        ),
                      ],
                    );
                  },
                  medium: () {
                    return const SizedBox();
                  },
                ),
                const SpaceH20(),
                const SpaceH24(),
                SPrimaryButton2(
                  active: true,
                  name: intl.previewBuyWithAsset_confirm,
                  onTap: () {
                    sAnalytics.globalSendConfirmOrderSummary(
                      asset: data.asset ?? '',
                      sendMethodType: '1',
                      destCountry: data.countryCode ?? '',
                      paymentMethod: method.name ?? '',
                      globalSendType: method.methodId ?? '',
                      totalSendAmount: (data.amount ?? Decimal.zero).toString(),
                    );

                    sRouter.push(
                      PinScreenRoute(
                        union: const Change(),
                        isChangePhone: true,
                        onChangePhone: (String newPin) {
                          sAnalytics.globalSenBioApprove(
                            asset: data.asset ?? '',
                            sendMethodType: '1',
                            destCountry: data.countryCode ?? '',
                            paymentMethod: method.name ?? '',
                            globalSendType: method.methodId ?? '',
                            totalSendAmount: (data.amount ?? Decimal.zero).toString(),
                          );

                          sRouter.maybePop();
                          state.confirmSendGlobally(newPin: newPin);
                        },
                        onWrongPin: (error) {
                          sAnalytics.errorWrongPin(
                            asset: data.asset ?? '',
                            errorText: error,
                            sendMethod: AnalyticsSendMethods.globally,
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
