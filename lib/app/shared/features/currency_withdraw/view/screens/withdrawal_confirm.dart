import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../../../../shared/components/pin_code_field.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/helpers/open_email_app.dart';
import '../../../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../model/withdrawal_model.dart';
import '../../notifier/withdrawal_confirm_notifier/withdrawal_confirm_notipod.dart';
import '../../notifier/withdrawal_confirm_notifier/withdrawal_confirm_state.dart';
import '../../notifier/withdrawal_preview_notifier/withdrawal_preview_notipod.dart';
import '../../provider/withdraw_dynamic_link_stpod.dart';

late WithdrawalModel withdrawalModel;

class WithdrawalConfirm extends HookWidget {
  const WithdrawalConfirm({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    withdrawalModel = withdrawal;

    final intl = useProvider(intlPod);
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
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final loader = useValueNotifier(StackLoaderNotifier());
    final pinError = useValueNotifier(StandardFieldErrorNotifier());
    final focusNode = useFocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          confirm.controller.value.text.length == emailVerificationCodeLength &&
          pinError.value.value) {
        confirm.controller.clear();
      }
    });

    final verb = withdrawal.dictionary.verb.toLowerCase();
    final noun = withdrawal.dictionary.noun.toLowerCase();

    return ProviderListener<WithdrawalConfirmState>(
      provider: withdrawalConfirmNotipod(withdrawal),
      onChange: (_, state) {
        state.union.maybeWhen(
          error: (Object? error) {
            loader.value.finishLoading();
            pinError.value.enableError();
            notificationN.showError(
              error.toString(),
              id: 1,
            );
          },
          orElse: () {},
        );
      },
      child: SPageFrameWithPadding(
        loading: loader.value,
        header: SMegaHeader(
          title: '${intl.confirm} $verb ${intl.request}',
          titleAlign: TextAlign.start,
          showBackButton: false,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Baseline(
              baseline: 24.0,
              baselineType: TextBaseline.alphabetic,
              child: Text(
                '${intl.confirmYour} $noun ${intl.withdrawalConfirm_text}:',
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
            const SpaceH24(),
            SClickableLinkText(
              text: intl.openEmailApp,
              onTap: () => openEmailApp(context),
            ),
            const SpaceH29(),
            PinCodeField(
              focusNode: focusNode,
              controller: confirm.controller,
              length: emailVerificationCodeLength,
              onCompleted: (_) {
                loader.value.startLoading();
                confirmN.verifyCode();
              },
              autoFocus: true,
              onChanged: (_) {
                pinError.value.disableError();
              },
              pinError: pinError.value,
            ),
            SResendButton(
              active: !dynamicLink.state && !confirm.isResending,
              timer: timer,
              onTap: () {
                confirm.controller.clear();

                confirmN.withdrawalResend(
                  onSuccess: timerN.refreshTimer,
                );
              },
              text1: intl.you_can_resend_in,
              text2: intl.seconds,
              text3: intl.didnt_receive_the_code,
              textResend: intl.resend,
            ),
            const Spacer(),
            SSecondaryButton1(
              active: true,
              name: intl.cancelRequest,
              onTap: () => navigateToRouter(context.read),
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
