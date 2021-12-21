import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/open_email_app.dart';
import '../../../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../models/currency_model.dart';
import '../../notifier/send_by_phone_confirm_notifier/send_by_phone_confirm_notipod.dart';
import '../../notifier/send_by_phone_preview_notifier/send_by_phone_preview_notipod.dart';
import '../../provider/send_by_phone_dynamic_link_stpod.dart';

class SendByPhoneConfirm extends HookWidget {
  const SendByPhoneConfirm({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final timer = useProvider(timerNotipod(withdrawalConfirmResendCountdown));
    final timerN = useProvider(
      timerNotipod(withdrawalConfirmResendCountdown).notifier,
    );
    final confirm = useProvider(sendByPhoneConfirmNotipod(currency));
    final confirmN = useProvider(sendByPhoneConfirmNotipod(currency).notifier);
    final id = useProvider(sendByPhonePreviewNotipod(currency)).operationId;
    final dynamicLink = useProvider(sendByPhoneDynamicLinkStpod(id));
    // ignore: unused_local_variable
    final loader = useValueNotifier(StackLoaderNotifier());

    final colors = useProvider(sColorPod);
    final authInfo = useProvider(authInfoNotipod);

    return SPageFrameWithPadding(
      header: SMegaHeader(
        title: 'Confirm Send request',
        titleAlign: TextAlign.start,
        onBackButtonTap: () => navigateToRouter(context.read),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Baseline(
            baseline: 24.0,
            baselineType: TextBaseline.alphabetic,
            child: Text(
              'Confirm your send request by opening the link in '
              'the email we sent to:',
              maxLines: 3,
              style: sBodyText1Style.copyWith(
                color: colors.grey1,
              ),
            ),
          ),
          Text(
            authInfo.email,
            maxLines: 2,
            style: sBodyText1Style,
          ),
          const SpaceH16(),
          SClickableLinkText(
            text: 'Open email app',
            onTap: () => openEmailApp(context),
          ),
          const Spacer(),
          SResendButton(
            active: !dynamicLink.state && !confirm.isResending,
            timer: timer,
            onTap: () {
              confirmN.transferResend(
                then: () => timerN.refreshTimer(),
              );
            },
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
