import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../model/preview_buy_with_asset_input.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_buy_with_asset_notipod.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_buy_with_asset_state.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_buy_with_asset_union.dart';

class PreviewBuyWithAsset extends StatefulHookWidget {
  const PreviewBuyWithAsset({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithAssetInput input;

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
    final state = useProvider(previewBuyWithAssetNotipod(widget.input));
    final notifier = useProvider(
      previewBuyWithAssetNotipod(widget.input).notifier,
    );
    final loader = useValueNotifier(StackLoaderNotifier());

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
        header: SMegaHeader(
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
              iconUrl: widget.input.toCurrency.iconUrl,
            ),
            const Spacer(),
            SActionConfirmText(
              name: 'You Pay',
              value: '${state.fromAssetAmount} '
                  '${state.fromAssetSymbol}',
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
