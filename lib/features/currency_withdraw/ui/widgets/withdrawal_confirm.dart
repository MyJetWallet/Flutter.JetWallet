import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_confirm_union.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_address_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_confirm_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_preview_store.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/helpers/open_email_app.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/pin_code_field.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../model/withdrawal_model.dart';

late WithdrawalModel withdrawalModel;

class WithdrawalConfirm extends StatefulWidget {
  const WithdrawalConfirm({
    Key? key,
    required this.withdrawal,
    required this.addressStore,
    required this.previewStore,
  }) : super(key: key);

  final WithdrawalModel withdrawal;
  final WithdrawalAddressStore addressStore;
  final WithdrawalPreviewStore previewStore;

  @override
  State<WithdrawalConfirm> createState() => _WithdrawalConfirmState();
}

class _WithdrawalConfirmState extends State<WithdrawalConfirm> {
  @override
  void initState() {
    getIt.get<WithdrawalConfirmStore>().setNewOperation(
          widget.withdrawal,
          widget.previewStore,
          widget.addressStore,
        );
    super.initState();
  }

  @override
  void dispose() {
    getIt.get<WithdrawalConfirmStore>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TimerStore>(
          create: (_) => TimerStore(withdrawalConfirmResendCountdown),
          dispose: (context, store) => store.dispose(),
        ),
      ],
      builder: (context, child) {
        return _WithdrawalConfirmBody(
          withdrawal: widget.withdrawal,
        );
      },
    );
  }
}

class _WithdrawalConfirmBody extends StatelessObserverWidget {
  const _WithdrawalConfirmBody({
    Key? key,
    required this.withdrawal,
  }) : super(key: key);

  final WithdrawalModel withdrawal;

  @override
  Widget build(BuildContext context) {
    withdrawalModel = withdrawal;

    final colors = sKit.colors;
    final timer = TimerStore.of(context);

    final authInfo = getIt.get<AppStore>().authState;

    final confirm = getIt.get<WithdrawalConfirmStore>();

    //final id = WithdrawalPreviewStore.of(context);

    final dynamicLink = getIt.get<AppStore>().withdrawDynamicLink;

    final focusNode = getIt.get<WithdrawalConfirmStore>().focusNode;

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          confirm.controller.value.text.length == emailVerificationCodeLength &&
          confirm.pinError.value) {
        confirm.controller.clear();
      }
    });

    final verb = withdrawal.dictionary.verb.toLowerCase();
    final noun = withdrawal.dictionary.noun.toLowerCase();

    return ReactionBuilder(
      builder: (context) {
        return reaction<WithdrawalConfirmUnion>(
          (_) => confirm.union,
          (result) {
            result.maybeWhen(
              error: (Object? error) {
                confirm.loader.finishLoading();
                confirm.pinError.enableError();
                sNotification.showError(
                  error.toString(),
                  id: 1,
                );
              },
              orElse: () {},
            );
          },
          fireImmediately: true,
        );
      },
      child: SPageFrameWithPadding(
        loading: confirm.loader,
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
              focusNode: focusNode,
              controller: confirm.controller,
              length: emailVerificationCodeLength,
              onCompleted: (_) {
                confirm.loader.startLoading();
                confirm.verifyCode();
              },
              autoFocus: true,
              onChanged: (_) {
                confirm.pinError.disableError();
              },
              pinError: confirm.pinError,
            ),
            SResendButton(
              active: !dynamicLink && !confirm.isResending,
              timer: timer.time,
              onTap: () {
                confirm.controller.clear();

                confirm.withdrawalResend(
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
    );
  }
}
