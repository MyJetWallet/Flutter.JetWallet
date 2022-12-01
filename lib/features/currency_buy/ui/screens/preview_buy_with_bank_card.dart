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
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class PreviewBuyWithBankCard extends StatelessWidget {
  const PreviewBuyWithBankCard({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithBankCardInput input;

  @override
  Widget build(BuildContext context) {
    return Provider<PreviewBuyWithBankCardStore>(
      create: (context) => PreviewBuyWithBankCardStore(input),
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

    final state = PreviewBuyWithBankCardStore.of(context);

    final title =
        '${intl.previewBuyWithAsset_confirm} ${intl.previewBuyWithCircle_buy} '
        '${input.currency.description}';
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
                state.skippedWaiting();
              },
            )
          : null,
      header: deviceSize.when(
        small: () {
          return SSmallHeader(
            title: title,
          );
        },
        medium: () {
          return SMegaHeader(
            title: title,
          );
        },
      ),
      child: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(
              bottom: 100.0,
            ),
            children: [
              Column(
                children: [
                  deviceSize.when(
                    small: () => const SpaceH8(),
                    medium: () => const SpaceH3(),
                  ),
                  Center(
                    child: SActionConfirmIconWithAnimation(
                      iconUrl: input.currency.iconUrl,
                    ),
                  ),
                  if (heightWidget > 0) ...[
                    SizedBox(
                      height: heightWidget,
                    ),
                  ],
                  // const Spacer(),
                  SActionConfirmText(
                    name: intl.buySimplexDetails_payFrom,
                    contentLoading: state.loader.loading,
                    value:
                        ' •••• ${input.cardNumber != null ? input.cardNumber?.substring(
                            (input.cardNumber?.length ?? 4) - 4,
                          ) : ''}',
                    maxValueWidth: 200,
                  ),
                  SActionConfirmText(
                    name: intl.previewBuyWithUnlimint_paymentFee,
                    contentLoading: state.loader.loading,
                    value: state.depositFeeAmountMax == state.depositFeeAmount
                        ? volumeFormat(
                            prefix: baseCurrency.prefix,
                            decimal: state.depositFeeAmount ?? Decimal.zero,
                            accuracy: baseCurrency.accuracy,
                            symbol: baseCurrency.symbol,
                          )
                        : '≈ ${volumeFormat(
                            prefix: baseCurrency.prefix,
                            decimal: state.depositFeeAmountMax ?? Decimal.zero,
                            accuracy: baseCurrency.accuracy,
                            symbol: baseCurrency.symbol,
                          )}',
                    maxValueWidth: 140,
                    infoIcon: true,
                    infoAction: () {
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
                  ),
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
                    value: '≈ ${volumeFormat(
                      prefix: baseCurrency.prefix,
                      symbol: baseCurrency.symbol,
                      accuracy: baseCurrency.accuracy,
                      decimal: state.rate ?? Decimal.zero,
                    )}',
                  ),
                  const SpaceH20(),
                  Text(
                    intl.previewBuyWithCircle_description,
                    maxLines: 3,
                    style: sCaptionTextStyle.copyWith(
                      color: colors.grey3,
                    ),
                  ),
                  const SpaceH24(),
                  const SDivider(),
                  SActionConfirmText(
                    name: intl.previewBuyWithCircle_youWillPay,
                    contentLoading: state.loader.loading,
                    valueColor: colors.blue,
                    value: volumeFormat(
                      prefix: baseCurrency.prefix,
                      symbol: baseCurrency.symbol,
                      accuracy: baseCurrency.accuracy,
                      decimal: state.amountToPay!,
                    ),
                  ),
                  const SpaceH20(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                            const SpaceH7(),
                            SDivider(
                              color: colors.grey4,
                            ),
                            const SpaceH7(),
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
                  const SpaceH16(),
                ],
              ),
            ],
          ),
          SFloatingButtonFrame(
            hidePadding: true,
            button: SPrimaryButton2(
              active: !state.loader.loading && state.isChecked,
              name: intl.previewBuyWithAsset_confirm,
              onTap: () {
                sAnalytics.tapConfirmBuy(
                  assetName: input.currency.description,
                  paymentMethod: 'bankCard',
                  amount: formatCurrencyStringAmount(
                    prefix: baseCurrency.prefix,
                    value: input.amount,
                    symbol: baseCurrency.symbol,
                  ),
                  frequency: RecurringFrequency.oneTime,
                );
                state.onConfirm();
              },
            ),
          ),
        ],
      ),
    );
  }
}
