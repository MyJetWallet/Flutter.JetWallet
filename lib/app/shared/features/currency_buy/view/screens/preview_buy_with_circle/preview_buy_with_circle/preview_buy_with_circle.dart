import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../helpers/formatting/base/volume_format.dart';
import '../../../../../../providers/base_currency_pod/base_currency_pod.dart';
import '../../../../model/preview_buy_with_circle_input.dart';
import '../../../../notifier/preview_buy_with_circle_notifier/preview_buy_with_circle_notipod.dart';

class PreviewBuyWithCircle extends HookWidget {
  const PreviewBuyWithCircle({
    Key? key,
    required this.input,
  }) : super(key: key);

  final PreviewBuyWithCircleInput input;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final deviceSize = useProvider(deviceSizePod);
    final baseCurrency = useProvider(baseCurrencyPod);
    final state = useProvider(previewBuyWithCircleNotipod(input));
    final notifier = useProvider(previewBuyWithCircleNotipod(input).notifier);
    useValueListenable(state.loader);
    final title =
        '${intl.previewBuyWithAsset_confirm} ${intl.previewBuyWithCircle_buy} '
        '${input.currency.description}';

    return SPageFrameWithPadding(
      loading: state.loader,
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
                    iconUrl: input.currency.iconUrl,
                  ),
                ),
                const Spacer(),
                SActionConfirmText(
                  name: intl.previewBuyWithCircle_payFrom,
                  value: '${state.card?.network} •••• ${state.card?.last4}',
                ),
                SActionConfirmText(
                  name: intl.previewBuyWithCircle_creditCardFee,
                  contentLoading: state.loader.value,
                  value: '${state.feePercentage}%',
                ),
                SActionConfirmText(
                  name: intl.previewBuyWithCircle_youWillGet,
                  contentLoading: state.loader.value,
                  value: volumeFormat(
                    prefix: input.currency.prefixSymbol,
                    symbol: input.currency.symbol,
                    accuracy: input.currency.accuracy,
                    decimal: state.amountToGet!,
                  ),
                ),
                const SpaceH20(),
                Text(
                  intl.previewBuyWithCircle_description,
                  maxLines: 3,
                  style: sCaptionTextStyle.copyWith(
                    color: colors.grey3,
                  ),
                ),
                const SpaceH34(),
                const SDivider(),
                const SpaceH24(),
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
                const SpaceH36(),
                SPrimaryButton2(
                  active: !state.loader.value,
                  name: intl.previewBuyWithAsset_confirm,
                  onTap: () => notifier.onConfirm(),
                ),
                const SpaceH24(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
