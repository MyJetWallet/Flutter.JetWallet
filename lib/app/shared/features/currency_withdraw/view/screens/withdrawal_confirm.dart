import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/open_email_app.dart';
import '../../../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../model/withdrawal_model.dart';
import '../../notifier/withdrawal_confirm_notifier/withdrawal_confirm_notipod.dart';
import '../../notifier/withdrawal_preview_notifier/withdrawal_preview_notipod.dart';
import '../../provider/withdraw_dynamic_link_stpod.dart';

class WithdrawalConfirm extends HookWidget {
  const WithdrawalConfirm({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final timer = useProvider(timerNotipod(withdrawalConfirmResendCountdown));
    final timerN = useProvider(
      timerNotipod(withdrawalConfirmResendCountdown).notifier,
    );
    final authInfo = useProvider(authInfoNotipod);
    final confirm = useProvider(withdrawalConfirmNotipod(withdrawal));
    final confirmN = useProvider(withdrawalConfirmNotipod(withdrawal).notifier);
    final id = useProvider(withdrawalPreviewNotipod(withdrawal)).operationId;
    final dynamicLink = useProvider(withdrawDynamicLinkStpod(id));
    final loader = useValueNotifier(StackLoaderNotifier());

    final verb = withdrawal.dictionary.verb.toLowerCase();
    final noun = withdrawal.dictionary.noun.toLowerCase();

    return ProviderListener<StateController<bool>>(
      provider: withdrawDynamicLinkStpod(id),
      onChange: (_, value) {
        if (value.state) {
          loader.value.startLoading();
          confirmN.requestWithdrawalInfo().then((_) {
            loader.value.finishLoading();
          });
        } else {
          loader.value.finishLoading();
        }
      },
      child: SPageFrameWithPadding(
        loading: loader.value,
        header: SMegaHeader(
          title: 'Confirm $verb request',
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
                'Confirm your $noun request by opening the link in '
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
            SBaselineChild(
              baseline: 40.0,
              child: SClickableLinkText(
                text: 'Open email app',
                onTap: () => openEmailApp(context),
              ),
            ),
            const Spacer(),
            SResendButton(
              active: !dynamicLink.state && !confirm.isResending,
              timer: timer,
              onTap: () {
                confirmN.withdrawalResend(
                  onSuccess: timerN.refreshTimer,
                );
              },
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
