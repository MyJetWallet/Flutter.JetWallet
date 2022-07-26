import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/providers/device_size/device_size_pod.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../helpers/formatting/formatting.dart';
import '../../../../models/currency_model.dart';
import '../../notifier/send_by_phone_preview_notifier/send_by_phone_preview_notipod.dart';
import '../../notifier/send_by_phone_preview_notifier/send_by_phone_preview_state.dart';

class SendByPhonePreview extends HookWidget {
  const SendByPhonePreview({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final deviceSize = useProvider(deviceSizePod);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(sendByPhonePreviewNotipod(currency));
    final notifier = useProvider(sendByPhonePreviewNotipod(currency).notifier);
    final loader = useValueNotifier(StackLoaderNotifier());

    return ProviderListener<SendByPhonePreviewState>(
      provider: sendByPhonePreviewNotipod(currency),
      onChange: (_, state) {
        if (state.loading) {
          loader.value.startLoading();
        } else {
          loader.value.finishLoading();
        }
      },
      child: SPageFrameWithPadding(
        loading: loader.value,
        header: deviceSize.when(
          small: () {
            return SSmallHeader(
              title: '${intl.sendByPhonePreview_send} ${currency.description}'
                  ' ${intl.sendByPhonePreview_byPhone}',
            );
          },
          medium: () {
            return SMegaHeader(
              title: '${intl.sendByPhonePreview_send} ${currency.description}'
                  ' ${intl.sendByPhonePreview_byPhone}',
            );
          },
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  SActionConfirmIconWithAnimation(
                    iconUrl: currency.iconUrl,
                  ),
                  const Spacer(),
                  SActionConfirmText(
                    name: intl.sendByPhonePreview_youSendTo,
                    value: state.pickedContact!.phoneNumber,
                    valueDescription: state.pickedContact!.name,
                  ),
                  SActionConfirmText(
                    name: intl.sendByPhonePreview_amountToSend,
                    baseline: 35.0,
                    value: volumeFormat(
                      prefix: currency.prefixSymbol,
                      accuracy: currency.accuracy,
                      decimal: Decimal.parse(state.amount),
                      symbol: currency.symbol,
                    ),
                  ),
                  const SpaceH35(),
                  const SDivider(),
                  const SpaceH4(),
                  SActionConfirmText(
                    name: intl.sendByPhonePreview_total,
                    baseline: 35.0,
                    value: volumeFormat(
                      prefix: currency.prefixSymbol,
                      accuracy: currency.accuracy,
                      decimal: Decimal.parse(state.amount),
                      symbol: currency.symbol,
                    ),
                    valueColor: colors.blue,
                  ),
                  const SpaceH35(),
                  SPrimaryButton2(
                    active: !state.loading,
                    name: intl.sendByPhonePreview_confirm,
                    onTap: () {
                      sAnalytics.sendConfirm(
                        currency: currency.symbol,
                        amount: state.amount,
                        type: 'By phone',
                      );
                      notifier.send();
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
