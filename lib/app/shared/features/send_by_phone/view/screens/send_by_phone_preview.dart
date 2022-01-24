import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../models/currency_model.dart';
import '../../../currency_withdraw/helper/user_will_receive.dart';
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
        header: SMegaHeader(
          title: 'Send ${currency.description} by phone',
        ),
        child: Column(
          children: [
            const SpaceH24(),
            SActionConfirmIconWithAnimation(
              iconUrl: currency.iconUrl,
            ),
            const Spacer(),
            SActionConfirmText(
              name: 'You send to',
              value: state.pickedContact!.phoneNumber,
              valueDescription: state.pickedContact!.name,
            ),
            SActionConfirmText(
              name: 'Amount to send',
              baseline: 35.0,
              value: userWillreceive(
                currency: currency,
                amount: state.amount,
                addressIsInternal: false,
              ),
            ),
            const SpaceH35(),
            const SDivider(),
            const SpaceH4(),
            SActionConfirmText(
              name: 'Total',
              baseline: 35.0,
              value: '${state.amount} ${currency.symbol}',
              valueColor: colors.blue,
            ),
            const SpaceH35(),
            SPrimaryButton2(
              active: !state.loading,
              name: 'Confirm',
              onTap: () => notifier.send(),
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
