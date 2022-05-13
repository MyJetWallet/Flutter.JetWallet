import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/providers/service_providers.dart';
import '../../../helpers/formatting/formatting.dart';
import '../../../helpers/price_accuracy.dart';
import '../model/preview_sell_input.dart';
import '../notifier/preview_sell_notifier/preview_sell_notipod.dart';
import '../notifier/preview_sell_notifier/preview_sell_state.dart';
import '../notifier/preview_sell_notifier/preview_sell_union.dart';

class PreviewSell extends StatefulHookWidget {
  const PreviewSell({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewSellInput input;

  @override
  State<PreviewSell> createState() => _PreviewSell();
}

class _PreviewSell extends State<PreviewSell>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final notifier = context.read(
      previewSellNotipod(widget.input).notifier,
    );
    notifier.updateTimerAnimation(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final state = useProvider(previewSellNotipod(widget.input));
    final notifier = useProvider(previewSellNotipod(widget.input).notifier);
    final loader = useValueNotifier(StackLoaderNotifier());

    final from = widget.input.fromCurrency;
    final to = widget.input.toCurrency;

    final accuracy = priceAccuracy(context.read, from.symbol, to.symbol);

    return ProviderListener<PreviewSellState>(
      provider: previewSellNotipod(widget.input),
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
        header: SMegaHeader(
          title: notifier.previewHeader,
          onBackButtonTap: () {
            notifier.cancelTimer();
            Navigator.pop(context);
          },
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  SActionConfirmIconWithAnimation(
                    iconUrl: widget.input.fromCurrency.iconUrl,
                  ),
                  const Spacer(),
                  SActionConfirmText(
                    name: intl.youPay,
                    value: volumeFormat(
                      prefix: from.prefixSymbol,
                      accuracy: from.accuracy,
                      decimal: state.fromAssetAmount ?? Decimal.zero,
                      symbol: from.symbol,
                    ),
                  ),
                  SActionConfirmText(
                    name: intl.youGet,
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
                  SActionConfirmText(
                    name: intl.exchangeRate,
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
                  const SpaceH36(),
                  if (state.connectingToServer) ...[
                    const SActionConfirmAlert(),
                    const SpaceH20(),
                  ],
                  SPrimaryButton2(
                    active: state.union is QuoteSuccess,
                    name: intl.confirm,
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
