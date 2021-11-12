import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../components/convert_preview/view/components/quote_error_text.dart';
import '../model/preview_buy_with_asset_input.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_buy_with_asset_notipod.dart';
import '../notifier/preview_buy_with_asset_notifier/preview_buy_with_asset_union.dart';

class PreviewBuyWithAsset extends HookWidget {
  const PreviewBuyWithAsset({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithAssetInput input;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(previewBuyWithAssetNotipod(input));
    final notifier = useProvider(previewBuyWithAssetNotipod(input).notifier);

    return SPageFrameWithPadding(
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
          SActionConfirmIconWithGradientShadow(
            iconUrl: input.currency.iconUrl,
          ),
          const Spacer(),
          SActionConfirmText(
            name: 'You Pay',
            value: '${input.fromAssetAmount} ${input.fromAssetSymbol}',
          ),
          SActionConfirmText(
            name: 'You get',
            value: '≈ ${state.toAssetAmount} ${input.currency.symbol}',
          ),
          SActionConfirmText(
            name: 'Exchange Rate',
            value: '1 ${input.currency.symbol} = '
                '${state.price} ${input.fromAssetSymbol}',
          ),
          const SpaceH40(),
          if (state.connectingToServer) ...[
            QuoteErrorText(),
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
    );
  }
}
