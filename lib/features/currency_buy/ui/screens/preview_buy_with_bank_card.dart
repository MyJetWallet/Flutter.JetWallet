import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
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
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/helpers/widget_size_from.dart';

@RoutePage(name: 'PreviewBuyWithBankCardRouter')
class PreviewBuyWithBankCard extends StatelessWidget {
  const PreviewBuyWithBankCard({
    super.key,
    required this.input,
  });

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
    required this.input,
  });

  final PreviewBuyWithBankCardInput input;

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    final colors = sKit.colors;
    final deviceSize = sDeviceSize;
    final uAC = sSignalRModules.cards.cardInfos
        .where(
          (element) => element.integration == IntegrationType.unlimintAlt,
        )
        .toList();
    final activeCard = uAC.where((element) => element.id == input.cardId).toList();

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

    icon = state.isChecked ? const SCheckboxSelectedIcon() : const SCheckboxIcon();

    return SPageFrameWithPadding(
      loaderText: intl.register_pleaseWait,
      loading: state.loader,
      customLoader: state.isChecked
          ? WaitingScreen(
              wasAction: state.wasAction,
              onSkip: () {
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
            padding: EdgeInsets.only(
              bottom: widgetSizeFrom(deviceSize) == SWidgetSize.small ? 310.0 : 260,
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
                            : '''${activeCard.isNotEmpty ? activeCard[0].network.name : ''}'''
                                ''' •••• ${input.cardNumber != null ? input.cardNumber?.substring((input.cardNumber?.length ?? 4) - 4) : ''}''',
                    maxValueWidth: 200,
                    baseline: 24,
                  ),
                  const SpaceH19(),
                  SActionConfirmText(
                    name: intl.previewBuyWithUnlimint_paymentFee,
                    contentLoading: state.loader.loading,
                    value: state.depositFeeAmountMax == state.depositFeeAmount
                        ? volumeFormat(
                            decimal: state.depositFeeAmount ?? Decimal.zero,
                            accuracy: input.currencyPayment.accuracy,
                            symbol: input.currencyPayment.symbol,
                          )
                        : '≈ ${volumeFormat(
                            decimal: state.depositFeeAmountMax ?? Decimal.zero,
                            accuracy: input.currencyPayment.accuracy,
                            symbol: input.currencyPayment.symbol,
                          )}',
                    maxValueWidth: 140,
                    infoIcon: true,
                    infoAction: () {
                      showTransactionFeeBottomSheet(
                        context: context,
                        colors: colors,
                        isAbsolute: state.depositFeeAmountMax == state.depositFeeAmount,
                        tradeFeeAbsolute: volumeFormat(
                          decimal: state.depositFeeAmount ?? Decimal.zero,
                          accuracy: input.currencyPayment.accuracy,
                          symbol: input.currencyPayment.symbol,
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
                              userAgreementText: ''' ${intl.previewBuyWithUmlimint_disclaimerTerms}''',
                              betweenText: ', ',
                              privacyPolicyText: intl.previewBuyWithUmlimint_disclaimerPolicy,
                              onUserAgreementTap: () => launchURL(context, userAgreementLink),
                              onPrivacyPolicyTap: () => launchURL(context, privacyPolicyLink),
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
                SPrimaryButton2(
                  active: !state.loader.loading && (state.isChecked || hideCheckbox),
                  name: intl.previewBuyWithAsset_confirm,
                  onTap: () {
                    state.onConfirm();
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
