import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../../../shared/components/result_screens/waiting_screen/waiting_screen.dart';
import '../../../../../../shared/helpers/launch_url.dart';
import '../../../../helpers/format_currency_string_amount.dart';
import '../../../../helpers/formatting/formatting.dart';
import '../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../model/preview_buy_with_bank_card_input.dart';
import '../../notifier/preview_buy_with_bank_card_notifier/preview_buy_with_bank_card_notipod.dart';

class PreviewBuyWithBankCard extends HookWidget {
  const PreviewBuyWithBankCard({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithBankCardInput input;

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final state = useProvider(previewBuyWithBankCardNotipod(input));
    final notifier = useProvider(previewBuyWithBankCardNotipod(input).notifier);
    useValueListenable(state.loader);
    final title =
        '${intl.previewBuyWithAsset_confirm} ${intl.previewBuyWithCircle_buy} '
        '${input.currency.description}';
    var heightWidget = MediaQuery.of(context).size.height - 625;
    deviceSize.when(
        small: () => heightWidget = heightWidget - 120,
        medium: () => heightWidget = heightWidget - 180,
    );

    if (state.isChecked) {
      icon = const SCheckboxSelectedIcon();
    } else {
      icon = const SCheckboxIcon();
    }

    return SPageFrameWithPadding(
      loading: state.loader,
      customLoader: state.isChecked ? WaitingScreen(
        wasAction: state.wasAction,
        onSkip: () {
          notifier.skippedWaiting();
        },
      ) : null,
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
                    name: intl.previewBuyWithCircle_creditCardFee,
                    contentLoading: state.loader.value,
                    value: volumeFormat(
                      prefix: baseCurrency.prefix,
                      decimal: state.depositFeeAmount ?? Decimal.zero,
                      accuracy: baseCurrency.accuracy,
                      symbol: baseCurrency.symbol,
                    ),
                    maxValueWidth: 140,
                  ),
                  SActionConfirmText(
                    name: intl.previewBuyWithCircle_transactionFee,
                    contentLoading: state.loader.value,
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
                    contentLoading: state.loader.value,
                    value: '≈ ${volumeFormat(
                      prefix: input.currency.prefixSymbol,
                      symbol: input.currency.symbol,
                      accuracy: input.currency.accuracy,
                      decimal: state.buyAmount ?? Decimal.zero,
                    )}',
                  ),
                  SActionConfirmText(
                    name: intl.previewBuyWithCircle_rate,
                    contentLoading: state.loader.value,
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
                    contentLoading: state.loader.value,
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
                              notifier.checkSetter();
                            },
                            defaultIcon: icon,
                            pressedIcon: icon,
                          ),
                        ],
                      ),
                      const SpaceW10(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 82,
                        child: SPolicyText(
                          firstText: intl.previewBuyWithUmlimint_disclaimer,
                          userAgreementText:
                            ' ${intl.previewBuyWithUmlimint_disclaimerTerms}',
                          betweenText: ', ',
                          privacyPolicyText:
                          '${intl.previewBuyWithUmlimint_disclaimerPolicy}.',
                          onUserAgreementTap: () =>
                              launchURL(context, userAgreementLink),
                          onPrivacyPolicyTap: () =>
                              launchURL(context, privacyPolicyLink),
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
              active: !state.loader.value && state.isChecked,
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
                notifier.onConfirm();
              },
            ),
          ),
        ],
      ),
    );
  }
}
