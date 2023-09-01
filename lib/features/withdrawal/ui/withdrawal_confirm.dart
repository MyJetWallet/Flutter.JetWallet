import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_confirm_union.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/helpers/open_email_app.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/pin_code_field.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'WithdrawalConfirmRouter')
class WithdrawalConfirmScreen extends StatelessWidget {
  const WithdrawalConfirmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<TimerStore>(
      create: (context) => TimerStore(withdrawalConfirmResendCountdown),
      builder: (context, child) => const WithdrawalConfirmScreenBody(),
      dispose: (context, value) => value.dispose(),
    );
  }
}

class WithdrawalConfirmScreenBody extends StatelessObserverWidget {
  const WithdrawalConfirmScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final timer = TimerStore.of(context);
    final store = WithdrawalStore.of(context);

    final authInfo = getIt<AppStore>().authState;
    final dynamicLink = getIt.get<AppStore>().withdrawDynamicLink;

    final verb = intl.withdrawal_send_verb.toLowerCase();
    final noun = intl.withdrawal_send_noun.toLowerCase();

    return WillPopScope(
      onWillPop: () async => false,
      child: ReactionBuilder(
        builder: (context) {
          return reaction<WithdrawalConfirmUnion>(
            (_) => store.confirmUnion,
            (result) {
              result.maybeWhen(
                error: (Object? error) {
                  store.confirmLoader.finishLoadingImmediately();

                  sNotification.showError(
                    error.toString(),
                    id: 1,
                  );
                },
                input: () {
                  store.confirmLoader.finishLoadingImmediately();
                },
                orElse: () {},
              );
            },
            fireImmediately: true,
          );
        },
        child: SPageFrameWithPadding(
          loaderText: intl.register_pleaseWait,
          loading: store.confirmLoader,
          customLoader: store.withdrawalType == WithdrawalType.nft
              ? store.confirmIsProcessing
                  ? WaitingScreen(
                      onSkip: () {},
                    )
                  : null
              : null,
          header: SMegaHeader(
            title: '${intl.withdrawalConfirm_confirm} $verb'
                ' ${intl.withdrawalConfirm_request}',
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
                  '${intl.withdrawalConfirm_confirmYour} $noun'
                  ' ${intl.withdrawalConfirm_text}:',
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
                text: intl.withdrawalConfirm_openEmailApp,
                onTap: () => openEmailApp(context),
              ),
              const SpaceH29(),
              PinCodeField(
                focusNode: store.confirmFocusNode,
                controller: store.confirmController,
                length: emailVerificationCodeLength,
                onCompleted: (_) {
                  store.verifyCode();
                },
                autoFocus: true,
                onChanged: (_) {
                  store.pinError.disableError();
                },
                pinError: store.pinError,
              ),
              SResendButton(
                active: !dynamicLink && !store.isResending,
                timer: timer.time,
                onTap: () {
                  store.confirmController.clear();

                  store.withdrawalResend(
                    onSuccess: timer.refreshTimer,
                  );
                },
                text1: intl.withdrawalConfirm_youCanResendIn,
                text2: intl.withdrawalConfirm_seconds,
                text3: intl.withdrawalConfirm_didntReceiveTheCode,
                textResend: intl.withdrawalConfirm_resend,
              ),
              const Spacer(),
              SSecondaryButton1(
                active: true,
                name: intl.withdrawalConfirm_cancelRequest,
                onTap: () => navigateToRouter(),
              ),
              const SpaceH24(),
            ],
          ),
        ),
      ),
    );
  }
}
