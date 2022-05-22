import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/format_currency_string_amount.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../../helpers/price_accuracy.dart';
import '../../recurring/helper/recurring_buys_operation_name.dart';
import '../../wallet/helper/format_date_to_hm.dart';
import '../model/preview_buy_with_asset_input.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_buy_with_asset_notipod.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_buy_with_asset_state.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_buy_with_asset_union.dart';

class PreviewBuyWithAsset extends StatefulHookWidget {
  const PreviewBuyWithAsset({
    Key? key,
    this.onBackButtonTap,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithAssetInput input;
  final void Function()? onBackButtonTap;

  @override
  State<PreviewBuyWithAsset> createState() => _PreviewBuyWithAssetState();
}

class _PreviewBuyWithAssetState extends State<PreviewBuyWithAsset>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final notifier = context.read(
      previewBuyWithAssetNotipod(widget.input).notifier,
    );
    final intl = context.read(intlPod);
    notifier.updateTimerAnimation(_animationController);
    sAnalytics.previewBuyView(
      widget.input.toCurrency.description,
      intl.previewBuyWithAsset_crypto,
      formatCurrencyStringAmount(
        prefix: widget.input.fromCurrency.prefixSymbol,
        value: widget.input.amount,
        symbol: widget.input.fromCurrency.symbol,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(previewBuyWithAssetNotipod(widget.input));
    final notifier = useProvider(
      previewBuyWithAssetNotipod(widget.input).notifier,
    );
    final loader = useValueNotifier(StackLoaderNotifier());

    final from = widget.input.fromCurrency;
    final to = widget.input.toCurrency;

    final accuracy = priceAccuracy(context.read, from.symbol, to.symbol);

    return ProviderListener<PreviewBuyWithAssetState>(
      provider: previewBuyWithAssetNotipod(widget.input),
      onChange: (_, value) {
        if (value.union is ExecuteLoading) {
          loader.value.startLoading();
        } else {
          if (loader.value.value) {
            loader.value.finishLoading();
          }
        }
      },
      child: SPageFrameWithPadding(
        loading: loader.value,
        header: deviceSize.when(
          small: () {
            return SSmallHeader(
              title: notifier.previewHeader,
              onBackButtonTap: widget.onBackButtonTap ??
                  () {
                    notifier.cancelTimer();
                    Navigator.pop(context);
                  },
            );
          },
          medium: () {
            return SMegaHeader(
              title: notifier.previewHeader,
              onBackButtonTap: widget.onBackButtonTap ??
                  () {
                    notifier.cancelTimer();
                    Navigator.pop(context);
                  },
            );
          },
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  deviceSize.when(
                    small: () => const SpaceH8(),
                    medium: () => const SpaceH3(),
                  ),
                  Center(
                    child: SActionConfirmIconWithAnimation(
                      iconUrl: widget.input.toCurrency.iconUrl,
                    ),
                  ),
                  const Spacer(),
                  SActionConfirmText(
                    name: intl.previewBuyWithAsset_youPay,
                    value: volumeFormat(
                      prefix: from.prefixSymbol,
                      accuracy: from.accuracy,
                      decimal: state.fromAssetAmount ?? Decimal.zero,
                      symbol: from.symbol,
                    ),
                  ),
                  if (!state.recurring)
                    SActionConfirmText(
                      name: intl.previewBuyWithAsset_youGet,
                      baseline: 35.0,
                      contentLoading: state.union is QuoteLoading,
                      value: '≈ ${volumeFormat(
                        prefix: to.prefixSymbol,
                        accuracy: to.accuracy,
                        decimal: state.toAssetAmount ?? Decimal.zero,
                        symbol: to.symbol,
                      )}',
                    ),
                  SActionConfirmText(
                    name: intl.fee,
                    baseline: 35.0,
                    contentLoading: state.union is QuoteLoading,
                    value: '${state.feePercent}%',
                  ),
                  if (!state.recurring)
                    SActionConfirmText(
                      name: intl.previewBuyWithAsset_exchangeRate,
                      baseline: 34.0,
                      contentLoading: state.union is QuoteLoading,
                      timerLoading: state.union is QuoteLoading,
                      animation: state.timerAnimation,
                      value: '${volumeFormat(
                        prefix: from.prefixSymbol,
                        accuracy: from.accuracy,
                        decimal: Decimal.one,
                        symbol: from.symbol,
                      )} = \n'
                          '${volumeFormat(
                        prefix: to.prefixSymbol,
                        accuracy: accuracy,
                        decimal: state.price ?? Decimal.zero,
                        symbol: to.symbol,
                      )}',
                    ),
                  if (state.recurring) ...[
                    SActionConfirmText(
                      name: intl.account_recurringBuy,
                      baseline: 35.0,
                      contentLoading: state.union is QuoteLoading,
                      value: '${recurringBuysOperationName(
                        state.recurringType,
                        context,
                      )} - ${formatDateToHm(
                        state.recurringBuyInfo?.nextExecutionTime,
                      )}',
                    ),
                    const SpaceH20(),
                    Text(
                      '${intl.previewBuyWith_theAmountOf}'
                          ' ${state.toAssetSymbol} '
                          '${intl.previewBuyWith_text1}',
                      style: sCaptionTextStyle.copyWith(color: colors.grey3),
                      maxLines: 4,
                    ),
                    const SpaceH34(),
                    const SDivider(),
                    const SpaceH5(),
                    SActionConfirmText(
                      name: intl.previewBuyWithAsset_nextPayment,
                      baseline: 35.0,
                      contentLoading: state.union is QuoteLoading,
                      value: '${convertDateToTomorrowOrDate(
                        state.recurringBuyInfo?.nextExecutionTime,
                        context,
                      )} - ${formatDateToHm(
                        state.recurringBuyInfo?.nextExecutionTime,
                      )}',
                    ),
                  ],
                  const SpaceH36(),
                  if (state.connectingToServer) ...[
                    const SActionConfirmAlert(),
                    const SpaceH20(),
                  ],
                  SPrimaryButton2(
                    active: state.union is QuoteSuccess,
                    name: intl.previewBuyWithAsset_confirm,
                    onTap: () {
                      notifier.executeQuote();
                    },
                  ),
                  const SpaceH24(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
