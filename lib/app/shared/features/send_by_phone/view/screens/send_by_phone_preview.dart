import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../models/currency_model.dart';
import '../../../currency_withdraw/helper/user_will_receive.dart';
import '../../notifier/send_by_phone_input_notifier/send_by_phone_input_notipod.dart';
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
    final colors = useProvider(sColorPod);
    final input = useProvider(sendByPhoneInputNotipod);
    final preview = useProvider(sendByPhonePreviewNotipod(currency));
    final previewN = useProvider(sendByPhonePreviewNotipod(currency).notifier);
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
        header: SMegaHeader(
          title: 'Confirm Send ${currency.description}',
        ),
        child: Column(
          children: [
            const Spacer(),
            SActionConfirmIconWithAnimation(
              iconUrl: currency.iconUrl,
            ),
            const Spacer(),
            SActionConfirmText(
              name: 'You send to',
              value: input.fullNumber,
            ),
            SActionConfirmText(
              name: 'Amount to send',
              value: userWillreceive(
                currency: currency,
                amount: preview.amount,
                addressIsInternal: false,
              ),
            ),
            const SBaselineChild(
              baseline: 40.0,
              child: SDivider(),
            ),
            SActionConfirmText(
              name: 'Total',
              value: '${preview.amount} ${currency.symbol}',
              valueColor: colors.blue,
            ),
            const SpaceH40(),
            SPrimaryButton2(
              active: !preview.loading,
              name: 'Confirm',
              onTap: () {
                previewN.send();
              },
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
