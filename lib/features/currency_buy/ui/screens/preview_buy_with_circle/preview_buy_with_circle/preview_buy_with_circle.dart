import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/device_size/device_size.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_circle_input.dart';
import 'package:jetwallet/features/currency_buy/store/preview_buy_with_circle_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

class PreviewBuyWithCircle extends StatelessWidget {
  const PreviewBuyWithCircle({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithCircleInput input;

  @override
  Widget build(BuildContext context) {
    return Provider<PreviewBuyWithCircleStore>(
      create: (context) => PreviewBuyWithCircleStore(input),
      builder: (context, child) => _PreviewBuyWithCircleBody(
        input: input,
      ),
    );
  }
}

class _PreviewBuyWithCircleBody extends StatelessObserverWidget {
  const _PreviewBuyWithCircleBody({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithCircleInput input;

  @override
  Widget build(BuildContext context) {
    late Widget icon;
    final colors = sKit.colors;
    final deviceSize = sDeviceSize;
    final baseCurrency = sSignalRModules.baseCurrency;

    final state = PreviewBuyWithCircleStore.of(context);

    final title =
        '${intl.previewBuyWithAsset_confirm} ${intl.previewBuyWithCircle_buy} '
        '${input.currency.description}';

    final cards = sSignalRModules.cards;

    var heightWidget = MediaQuery.of(context).size.height - 690;
    deviceSize.when(
      small: () => heightWidget = heightWidget - 120,
      medium: () => heightWidget = heightWidget - 180,
    );

    if (cards.cardInfos.isNotEmpty) {
      final actualCard = cards.cardInfos
          .where(
            (element) => element.id == state.card?.id,
          )
          .toList();
      if (actualCard.isNotEmpty) {
        final pendingNow = actualCard[0].status == CircleCardStatus.pending;
        if (!pendingNow && state.wasPending) {
          Timer(
            const Duration(
              milliseconds: 3000,
            ),
            () {
              state.setWasPending(value: false);
            },
          );
        }
        if (actualCard[0].status == CircleCardStatus.failed) {
          Timer(
            const Duration(
              seconds: 1,
            ),
            () => state.showFailure(),
          );
        } else {
          Timer(
            const Duration(
              milliseconds: 1000,
            ),
            () {
              state.setIsPending(pending: pendingNow);
            },
          );
        }
      }
    }

    icon =
        state.isChecked ? const SCheckboxSelectedIcon() : const SCheckboxIcon();

    return SPageFrameWithPadding(
      loading: state.loader,
      loaderText: intl.previewBuyWithCircle_pleaseWait,
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
                  if (!state.wasPending && heightWidget > 0) ...[
                    SizedBox(
                      height: heightWidget,
                    ),
                  ],
                  // const Spacer(),
                  SActionConfirmText(
                    name: intl.previewBuyWithCircle_payFrom,
                    value: '${state.card?.network} •••• ${state.card?.last4}',
                  ),
                  SActionConfirmText(
                    name: intl.previewBuyWithCircle_creditCardFee,
                    contentLoading: state.loader.loading,
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
                  if (state.wasPending) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(
                          color: colors.grey4,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 3,
                              ),
                              child: state.isPending
                                  ? DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: colors.grey5,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const LoaderSpinner(),
                                    )
                                  : const SCompleteDoneIcon(),
                            ),
                            const SpaceW10(),
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 124,
                              child: RichText(
                                text: TextSpan(
                                  text: state.isPending
                                      ? intl
                                          .previewBuyWithCircle_cardIsProcessing
                                      : intl.previewBuyWithCircle_cardIsReady,
                                  style: sBodyText1Style.copyWith(
                                    color: colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SpaceH10(),
                  ],
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
                        child: RichText(
                          text: TextSpan(
                            text: '${intl.previewBuyWithCircle_disclaimer} '
                                '$paymentDelayDays '
                                '${intl.previewBuyWithCircle_disclaimerEnd}',
                            style: sCaptionTextStyle.copyWith(
                              color: colors.black,
                            ),
                          ),
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
              active:
                  !state.loader.loading && !state.isPending && state.isChecked,
              name: intl.previewBuyWithAsset_confirm,
              onTap: () {
                sAnalytics.tapConfirmBuy(
                  assetName: input.currency.description,
                  paymentMethod: 'circleCard',
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
