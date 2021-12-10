import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../model/preview_convert_input.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_convert_notipod.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_convert_state.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_convert_union.dart';

class PreviewConvert extends StatefulHookWidget {
  const PreviewConvert({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewConvertInput input;

  @override
  State<PreviewConvert> createState() => _PreviewConvertState();
}

class _PreviewConvertState extends State<PreviewConvert>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final notifier = context.read(
      previewConvertNotipod(widget.input).notifier,
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
    final state = useProvider(previewConvertNotipod(widget.input));
    final notifier = useProvider(
      previewConvertNotipod(widget.input).notifier,
    );
    final loader = useValueNotifier(StackLoaderNotifier());

    return ProviderListener<PreviewConvertState>(
      provider: previewConvertNotipod(widget.input),
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
