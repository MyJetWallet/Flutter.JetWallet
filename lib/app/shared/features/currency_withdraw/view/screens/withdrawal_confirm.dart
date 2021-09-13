import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../../../shared/components/loader.dart';
import '../../../../../../shared/components/page_frame/page_frame.dart';
import '../../../../../../shared/components/spacers.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/open_email_app.dart';
import '../../../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../../../shared/providers/other/navigator_key_pod.dart';
import '../../../../models/currency_model.dart';
import '../../notifier/withdrawal_confirm_notifier/withdrawal_confirm_notipod.dart';
import '../../notifier/withdrawal_preview_notifier/withdrawal_preview_notipod.dart';
import '../../provider/withdraw_dynamic_link_stpod.dart';

class WithdrawalConfirm extends HookWidget {
  const WithdrawalConfirm({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  Widget build(BuildContext context) {
    final timer = useProvider(timerNotipod(5));
    final timerN = useProvider(timerNotipod(5).notifier);
    final authInfo = useProvider(authInfoNotipod);
    final confirmN = useProvider(withdrawalConfirmNotipod(currency).notifier);
    final navigatorKey = useProvider(navigatorKeyPod);
    final id = useProvider(withdrawalPreviewNotipod(currency)).operationId;
    final dynamicLink = useProvider(withdrawDynamicLinkStpod(id));

    return PageFrame(
      leftIcon: Icons.clear,
      onBackButton: () => navigateToRouter(navigatorKey),
      header: 'Confirm withdraw request',
      child: Column(
        mainAxisAlignment: dynamicLink.state
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (dynamicLink.state)
            const Loader()
          else ...[
            const SpaceH20(),
            Text(
              'Confirm your withdrawal request by opening the link in '
              'the email we sent to: ${authInfo.email}',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
              ),
            ),
            const SpaceH20(),
            Text(
              'This link expires in 1 hour',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
              ),
            ),
            const SpaceH2(),
            if (timer != 0)
              Text(
                'You can resend in $timer',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey,
                ),
              )
            else
              InkWell(
                onTap: () {
                  confirmN.withdrawalResend(
                    then: () => timerN.refreshTimer(),
                  );
                },
                child: Text(
                  'Resend',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black54,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            const Spacer(),
            AppButtonSolid(
              name: 'Open Email App',
              onTap: () => openEmailApp(context),
            ),
          ],
        ],
      ),
    );
  }
}
