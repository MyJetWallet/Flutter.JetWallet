import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

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
    final state = useProvider(previewSellNotipod(widget.input));
    final notifier = useProvider(previewSellNotipod(widget.input).notifier);
    final loader = useValueNotifier(StackLoaderNotifier());

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
        header: SBigHeader(
          title: notifier.previewHeader,
          onBackButtonTap: () {
            notifier.cancelTimer();
            Navigator.pop(context);
          },
        ),
        child: Column(
          children: [
            const Spacer(),
            SActionConfirmIconWithAnimation(
              iconUrl: widget.input.fromCurrency.iconUrl,
            ),
            const Spacer(),
            SActionConfirmText(
              name: 'You Pay',
              value: '${state.fromAssetAmount} ${state.fromAssetSymbol}',
            ),
            SActionConfirmText(
              name: 'You get',
              contentLoading: state.union is QuoteLoading,
              value: '≈ ${state.toAssetAmount} ${state.toAssetSymbol}',
            ),
            SActionConfirmText(
              name: 'Exchange Rate',
              contentLoading: state.union is QuoteLoading,
              timerLoading: state.union is QuoteLoading,
              animation: state.timerAnimation,
              value: '1 ${state.fromAssetSymbol} = '
                  '${state.price} ${state.toAssetSymbol}',
            ),
            const SpaceH40(),
            if (state.connectingToServer) ...[
              const SActionConfirmAlert(),
              const SpaceH20(),
            ],
            SPrimaryButton2(
              active: state.union is QuoteSuccess,
              name: 'Confirm',
              onTap: () {
                notifier.executeQuote();
              },
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
