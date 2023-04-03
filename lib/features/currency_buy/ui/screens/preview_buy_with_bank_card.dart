import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:jetwallet/features/currency_buy/models/apple_pay_config.dart';
import 'package:jetwallet/features/currency_buy/models/google_pay_config.dart';
import 'package:pay/pay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_bank_card_input.dart';
import 'package:jetwallet/features/currency_buy/store/preview_buy_with_bank_card_store.dart';
import 'package:jetwallet/features/currency_buy/ui/widgets/transaction_fee_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/helpers/widget_size_from.dart';

class PreviewBuyWithBankCard extends StatelessWidget {
  const PreviewBuyWithBankCard({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithBankCardInput input;

  @override
  Widget build(BuildContext context) {
    return Provider<PreviewBuyWithBankCardStore>(
      create: (context) => PreviewBuyWithBankCardStore(input, true),
      builder: (context, child) => _PreviewBuyWithBankCardBody(
        input: input,
      ),
    );
  }
}

class _PreviewBuyWithBankCardBody extends StatelessObserverWidget {
  const _PreviewBuyWithBankCardBody({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithBankCardInput input;

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    final colors = sKit.colors;
    final deviceSize = sDeviceSize;
    final baseCurrency = sSignalRModules.baseCurrency;
    final uAC = sSignalRModules.cards.cardInfos
        .where(
          (element) => element.integration == IntegrationType.unlimintAlt,
        )
        .toList();
    final activeCard =
        uAC.where((element) => element.id == input.cardId).toList();

    final state = PreviewBuyWithBankCardStore.of(context);
    final buyMethod = input.currency.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.bankCard,
        )
        .toList();
    final hideCheckbox = buyMethod.isNotEmpty && buyMethod[0].termsAccepted;

    var heightWidget = MediaQuery.of(context).size.height - 625;
    deviceSize.when(
      small: () => heightWidget = heightWidget - 120,
      medium: () => heightWidget = heightWidget - 180,
    );

    icon =
        state.isChecked ? const SCheckboxSelectedIcon() : const SCheckboxIcon();

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: state.loader,
      customLoader: state.isChecked
          ? WaitingScreen(
              wasAction: state.wasAction,
              onSkip: () {
                sAnalytics.newBuyTapCloseProcessing(
                  firstTimeBuy: '${!hideCheckbox}',
                );
                state.skippedWaiting();
              },
            )
          : null,
      header: const SSmallHeader(
        isShortVersion: true,
        title: '',
      ),
      child: Stack(
        children: [
          ListView(
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.only(
              bottom:
                  widgetSizeFrom(deviceSize) == SWidgetSize.small ? 310.0 : 260,
            ),
            children: [
              Column(
                children: [
                  deviceSize.when(
                    small: () => const SpaceH8(),
                    medium: () => const SpaceH3(),
                  ),
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          disclaimerAsset,
                          width: 80,
                          height: 80,
                        ),
                        const SpaceH16(),
                        Text(
                          intl.previewBuy_orderSummary,
                          style: sTextH5Style,
                        ),
                        const SpaceH32(),
                      ],
                    ),
                  ),
                  SActionConfirmText(
                    name: intl.previewBuyWithCircle_youWillGet,
                    contentLoading: state.loader.loading,
                    value: '≈ ${volumeFormat(
                      prefix: input.currency.prefixSymbol,
                      symbol: input.currency.symbol,
                      accuracy: input.currency.accuracy,
                      decimal: state.buyAmount ?? Decimal.zero,
                    )}',
                    baseline: 24,
                  ),
                  const SpaceH19(),
                  SActionConfirmText(
                    name: intl.previewBuyWithCircle_rate,
                    contentLoading: state.loader.loading,
                    value: '1 ${input.currency.symbol} = ${volumeFormat(
                      prefix: input.currencyPayment.prefixSymbol,
                      symbol: input.currencyPayment.symbol,
                      accuracy: input.currencyPayment.accuracy,
                      decimal: state.rate ?? Decimal.zero,
                    )}',
                    baseline: 24,
                  ),
                  const SpaceH19(),
                  SActionConfirmText(
                    name: intl.curencyBuy_payFrom,
                    contentLoading: state.loader.loading,
                    value: input.isApplePay
                        ? 'Apple Pay'
                        : input.isGooglePay
                            ? 'Google Pay'
                            : '${activeCard.isNotEmpty ? activeCard[0].network : ''}'
                                ' •••• ${input.cardNumber != null ? input.cardNumber?.substring(
                                    (input.cardNumber?.length ?? 4) - 4,
                                  ) : ''}',
                    maxValueWidth: 200,
                    baseline: 24,
                  ),
                  const SpaceH19(),
                  SActionConfirmText(
                    name: intl.previewBuyWithUnlimint_paymentFee,
                    contentLoading: state.loader.loading,
                    value: state.depositFeeAmountMax == state.depositFeeAmount
                        ? volumeFormat(
                            prefix: input.currencyPayment.prefixSymbol,
                            decimal: state.depositFeeAmount ?? Decimal.zero,
                            accuracy: input.currencyPayment.accuracy,
                            symbol: input.currencyPayment.symbol,
                          )
                        : '≈ ${volumeFormat(
                            prefix: input.currencyPayment.prefixSymbol,
                            decimal: state.depositFeeAmountMax ?? Decimal.zero,
                            accuracy: input.currencyPayment.accuracy,
                            symbol: input.currencyPayment.symbol,
                          )}',
                    maxValueWidth: 140,
                    infoIcon: true,
                    infoAction: () {
                      sAnalytics.newBuyTapPaymentFee();
                      sAnalytics.newBuyFeeView(
                        paymentFee: state.depositFeeAmountMax ==
                                state.depositFeeAmount
                            ? volumeFormat(
                                prefix: baseCurrency.prefix,
                                decimal: state.depositFeeAmount ?? Decimal.zero,
                                accuracy: baseCurrency.accuracy,
                                symbol: baseCurrency.symbol,
                              )
                            : '${state.depositFeePerc}%',
                      );
                      showTransactionFeeBottomSheet(
                        context: context,
                        colors: colors,
                        isAbsolute:
                            state.depositFeeAmountMax == state.depositFeeAmount,
                        tradeFeeAbsolute: volumeFormat(
                          prefix: baseCurrency.prefix,
                          decimal: state.depositFeeAmount ?? Decimal.zero,
                          accuracy: baseCurrency.accuracy,
                          symbol: baseCurrency.symbol,
                        ),
                        tradeFeePercentage: state.depositFeePerc,
                      );
                    },
                    baseline: 24,
                  ),
                  const SpaceH15(),
                  SActionConfirmText(
                    name: intl.previewBuyWithUnlimint_simpleFee,
                    contentLoading: state.loader.loading,
                    value: volumeFormat(
                      prefix: input.currency.prefixSymbol,
                      decimal: state.tradeFeeAmount ?? Decimal.zero,
                      accuracy: input.currency.accuracy,
                      symbol: input.currency.symbol,
                    ),
                    maxValueWidth: 140,
                    baseline: 24,
                  ),
                  const SpaceH17(),
                  Text(
                    intl.previewBuyWithCircle_description,
                    maxLines: 3,
                    style: sCaptionTextStyle.copyWith(
                      color: colors.grey3,
                    ),
                  ),
                  const SpaceH15(),
                  deviceSize.when(
                    small: () {
                      return const SizedBox();
                    },
                    medium: () {
                      return Column(
                        children: [
                          const SDivider(),
                          SActionConfirmText(
                            name: intl.currencyBuy_total,
                            contentLoading: state.loader.loading,
                            valueColor: colors.blue,
                            value: volumeFormat(
                              prefix: input.currencyPayment.prefixSymbol,
                              symbol: input.currencyPayment.symbol,
                              accuracy: input.currencyPayment.accuracy,
                              decimal: state.amountToPay!,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
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
                          name: intl.currencyBuy_total,
                          contentLoading: state.loader.loading,
                          valueColor: colors.blue,
                          value: volumeFormat(
                            prefix: input.currencyPayment.prefixSymbol,
                            symbol: input.currencyPayment.symbol,
                            accuracy: input.currencyPayment.accuracy,
                            decimal: state.amountToPay!,
                          ),
                        ),
                      ],
                    );
                  },
                  medium: () {
                    return const SizedBox.shrink();
                  },
                ),
                const SpaceH20(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!hideCheckbox)
                      Column(
                        children: [
                          SIconButton(
                            onTap: () {
                              sAnalytics.newBuyTapAgreement();
                              state.checkSetter();
                            },
                            defaultIcon: icon,
                            pressedIcon: icon,
                          ),
                        ],
                      ),
                    const SpaceW10(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 82,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!hideCheckbox) ...[
                            SPolicyText(
                              firstText: intl.previewBuyWithUmlimint_disclaimer,
                              userAgreementText:
                                  ' ${intl.previewBuyWithUmlimint_disclaimerTerms}',
                              betweenText: ', ',
                              privacyPolicyText:
                                  intl.previewBuyWithUmlimint_disclaimerPolicy,
                              onUserAgreementTap: () =>
                                  launchURL(context, userAgreementLink),
                              onPrivacyPolicyTap: () =>
                                  launchURL(context, privacyPolicyLink),
                            ),
                            const SpaceH14(),
                          ],
                          Text(
                            simpleCompanyName,
                            style: sCaptionTextStyle,
                          ),
                          Text(
                            simpleCompanyAddress,
                            style: sCaptionTextStyle,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SpaceH24(),
                if (!input.isApplePay && !input.isGooglePay) ...[
                  SPrimaryButton2(
                    active: !state.loader.loading &&
                        (state.isChecked || hideCheckbox),
                    name: intl.previewBuyWithAsset_confirm,
                    onTap: () {
                      state.onConfirm();
                    },
                  ),
                ] else if (input.isApplePay) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: ApplePayButton(
                      paymentConfiguration: PaymentConfiguration.fromJsonString(
                        jsonEncode(
                          ApplePayConfig(
                            provider: 'apple_pay',
                            data: ApplePayConfigData(
                              merchantIdentifier: 'merchant.app.simple.com',
                              displayName: displayName,
                              merchantCapabilities: merchantCapabilities,
                              supportedNetworks: supportedNetworks,
                              countryCode: countryCode,
                              currencyCode: input.currencyPayment.symbol,
                              requiredBillingContactFields: null,
                              requiredShippingContactFields: null,
                            ),
                          ),
                        ),
                      ),
                      height: 56,
                      width: double.infinity,
                      paymentItems: [
                        PaymentItem(
                          label: 'Simple.app',
                          amount: state.amountToPay!.toString(),
                          status: PaymentItemStatus.final_price,
                        ),
                      ],
                      style: ApplePayButtonStyle.black,
                      type: ApplePayButtonType.inStore,
                      onPaymentResult: (paymentResult) =>
                          state.requestApplePay(paymentResult),
                      loadingIndicator: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                ] else if (input.isGooglePay) ...[
                  GooglePayButton(
                    paymentConfiguration: PaymentConfiguration.fromJsonString(
                      jsonEncode(
                        GooglePayConfig(
                          provider: 'google_pay',
                          data: GooglePayConfigData(
                            environment: 'TEST',
                            apiVersion: 2,
                            apiVersionMinor: 0,
                            allowedPaymentMethods: [
                              GooglePayConfigAllowedPaymentMethod(
                                type: 'CARD',
                                tokenizationSpecification:
                                    GooglePayConfigTokenizationSpec(
                                  type: 'PAYMENT_GATEWAY',
                                  parameters: GooglePayConfigTokenSpecP(
                                    gateway: 'unlimint',
                                    gatewayMerchantId: 'googletest',
                                  ),
                                ),
                                parameters: GooglePayConfigParameters(
                                  allowedAuthMethods: [
                                    'PAN_ONLY',
                                    'CRYPTOGRAM_3DS'
                                  ],
                                  allowedCardNetworks: ['VISA', 'MASTERCARD'],
                                ),
                              ),
                            ],
                            merchantInfo: GooglePayConfigMerchantInfo(
                              merchantId: 'googletest',
                              merchantName: 'Test',
                            ),
                            transactionInfo: GooglePayConfigTransactionInfo(
                              countryCode: countryCode,
                              currencyCode: input.currencyPayment.symbol,
                            ),
                          ),
                        ),
                      ),
                    ),
                    paymentItems: [
                      PaymentItem(
                        label: 'Simple.app',
                        amount: state.amountToPay!.toString(),
                        status: PaymentItemStatus.final_price,
                      ),
                    ],
                    height: 56,
                    width: double.infinity,
                    type: GooglePayButtonType.plain,
                    onPaymentResult: (paymentResult) =>
                        state.requestGooglePay(paymentResult),
                    loadingIndicator: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
