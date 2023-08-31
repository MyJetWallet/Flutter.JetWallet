import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_unlimint_input.dart';
import 'package:jetwallet/features/currency_buy/store/preview_buy_with_unlimint_store.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/helpers/widget_size_from.dart';

@RoutePage(name: 'PreviewBuyWithUnlimintRouter')
class PreviewBuyWithUnlimint extends StatelessWidget {
  const PreviewBuyWithUnlimint({
    super.key,
    required this.input,
  });

  final PreviewBuyWithUnlimintInput input;

  @override
  Widget build(BuildContext context) {
    return Provider<PreviewBuyWithUnlimitStore>(
      create: (context) => PreviewBuyWithUnlimitStore(input),
      builder: (context, child) => _PreviewBuyWithUnlimintBody(
        input: input,
      ),
    );
  }
}

class _PreviewBuyWithUnlimintBody extends StatelessObserverWidget {
  const _PreviewBuyWithUnlimintBody({
    super.key,
    required this.input,
  });

  final PreviewBuyWithUnlimintInput input;

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    final colors = sKit.colors;
    final deviceSize = sDeviceSize;
    final baseCurrency = sSignalRModules.baseCurrency;
    final currencies = sSignalRModules.currenciesWithHiddenList;

    final state = PreviewBuyWithUnlimitStore.of(context);

    final title =
        '${intl.previewBuyWithAsset_confirm} ${intl.previewBuyWithCircle_buy} '
        '${input.currency.description}';
    var heightWidget = MediaQuery.of(context).size.height - 625;
    deviceSize.when(
      small: () => heightWidget = heightWidget - 120,
      medium: () => heightWidget = heightWidget - 180,
    );
    final buyMethod = input.currency.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.unlimintCard,
        )
        .toList();
    final hideCheckbox = buyMethod.isNotEmpty && buyMethod[0].termsAccepted;

    final transactionFeeCurrency = currencyFrom(
      currencies,
      state.tradeFeeAsset ?? '',
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
              bottom: widgetSizeFrom(deviceSize) == SWidgetSize.small
                  ? 310.0
                  : 260.0,
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
                        const SpaceH34(),
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
                  ),
                  SActionConfirmText(
                    name: intl.previewBuyWithCircle_rate,
                    contentLoading: state.loader.loading,
                    value: '1 ${input.currency.symbol} = ${volumeFormat(
                      prefix: input.currencyPayment.prefixSymbol,
                      symbol: input.currencyPayment.symbol,
                      accuracy: input.currencyPayment.accuracy,
                      decimal: state.rate ?? Decimal.zero,
                    )}',
                  ),
                  SActionConfirmText(
                    name: intl.previewBuyWithCircle_creditCardFee,
                    contentLoading: state.loader.loading,
                    value: volumeFormat(
                      prefix: transactionFeeCurrency.prefixSymbol,
                      decimal: state.depositFeeAmount ?? Decimal.zero,
                      accuracy: transactionFeeCurrency.accuracy,
                      symbol: transactionFeeCurrency.symbol,
                    ),
                    maxValueWidth: 140,
                  ),
                  SActionConfirmText(
                    name: intl.previewBuyWithCircle_transactionFee,
                    contentLoading: state.loader.loading,
                    value: volumeFormat(
                      prefix: input.currency.prefixSymbol,
                      decimal: state.tradeFeeAmount ?? Decimal.zero,
                      accuracy: input.currency.accuracy,
                      symbol: input.currency.symbol,
                    ),
                    maxValueWidth: 140,
                  ),
                  const SpaceH16(),
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
                  const SpaceH16(),
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
                    return const SizedBox();
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
                SPrimaryButton2(
                  active: !state.loader.loading &&
                      (state.isChecked || hideCheckbox),
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
