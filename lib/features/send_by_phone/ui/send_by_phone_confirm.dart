import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/send_by_phone/model/contact_model.dart';
import 'package:jetwallet/features/send_by_phone/model/send_by_phone_confirm_union.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_amount_store.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_confirm_store.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_preview_store.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/helpers/open_email_app.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/pin_code_field.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';

late CurrencyModel currencyModel;

class SendByPhoneConfirm extends StatefulObserverWidget {
  const SendByPhoneConfirm({
    Key? key,
    required this.currency,
    required this.operationId,
    required this.receiverIsRegistered,
    required this.amountStoreAmount,
    required this.pickedContact,
    required this.activeDialCode,
  }) : super(key: key);

  final CurrencyModel currency;
  final String operationId;
  final bool receiverIsRegistered;
  final String amountStoreAmount;
  final ContactModel pickedContact;
  final SPhoneNumber activeDialCode;

  @override
  State<SendByPhoneConfirm> createState() => _SendByPhoneConfirmState();
}

class _SendByPhoneConfirmState extends State<SendByPhoneConfirm> {
  @override
  void initState() {
    getIt.get<SendByPhoneConfirmStore>().initStore(
          widget.currency,
          SendByPhoneConfirmInput(
            operationId: widget.operationId,
            receiverIsRegistered: widget.receiverIsRegistered,
            toPhoneNumber: widget.pickedContact.phoneNumber,
          ),
        );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TimerStore>(
          create: (_) => TimerStore(withdrawalConfirmResendCountdown),
          dispose: (context, store) => store.dispose(),
        ),
        Provider<SendByPreviewStore>(
          create: (_) => SendByPreviewStore(
            widget.currency,
            widget.amountStoreAmount,
            widget.pickedContact,
            widget.activeDialCode,
          ),
        ),
      ],
      builder: (context, child) {
        return _SendByPhoneConfirmBody(
          currency: widget.currency,
        );
      },
    );
  }
}

class _SendByPhoneConfirmBody extends StatefulObserverWidget {
  const _SendByPhoneConfirmBody({
    Key? key,
    required this.currency,
  }) : super(key: key);

  final CurrencyModel currency;

  @override
  State<_SendByPhoneConfirmBody> createState() =>
      _SendByPhoneConfirmBodyState();
}

class _SendByPhoneConfirmBodyState extends State<_SendByPhoneConfirmBody> {
  late final FocusNode focusNode;

  @override
  void initState() {
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();

    print('DISPOSE');

    getIt.get<SendByPhoneConfirmStore>().clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    currencyModel = widget.currency;

    final timer = TimerStore.of(context);

    final confirm = getIt.get<SendByPhoneConfirmStore>();

    //final id = SendByPreviewStore.of(context).operationId;

    final dynamicLink = getIt.get<AppStore>().withdrawDynamicLink;

    final pinError = StandardFieldErrorNotifier();

    final colors = sKit.colors;
    final authInfo = getIt.get<AppStore>().authState;

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          confirm.controller.value.text.length == emailVerificationCodeLength &&
          pinError.value) {
        confirm.controller.clear();
      }
    });

    return ReactionBuilder(
      builder: (context) {
        return reaction<SendByPhoneConfirmUnion>(
          (_) => confirm.union,
          (result) {
            result.maybeWhen(
              error: (Object? error) {
                confirm.loader.finishLoading();
                pinError.enableError();
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
        loaderText: intl.register_pleaseWait,
        loading: confirm.loader,
        header: SMegaHeader(
          title: intl.sendByPhoneConfirm_confirmSendRequest,
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
                '${intl.sendByPhoneConfirm_description}:',
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
              text: intl.sendByPhoneConfirm_openEmailApp,
              onTap: () => openEmailApp(context),
            ),
            const SpaceH29(),
            PinCodeField(
              focusNode: focusNode,
              controller: confirm.controller,
              length: emailVerificationCodeLength,
              onCompleted: (_) {
                confirm.verifyCode();
              },
              autoFocus: true,
              onChanged: (_) {
                pinError.disableError();
              },
              pinError: pinError,
            ),
            SResendButton(
              active: !dynamicLink && !confirm.isResending,
              timer: timer.time,
              onTap: () {
                confirm.controller.clear();

                confirm.transferResend(
                  onSuccess: timer.refreshTimer,
                );
              },
              text1: intl.sendByPhoneConfirm_youCanResendIn,
              text2: intl.sendByPhoneConfirm_seconds,
              text3: intl.sendByPhoneConfirm_didntReceiveTheCode,
              textResend: intl.sendByPhoneConfirm_resend,
            ),
            const Spacer(),
            SSecondaryButton1(
              active: true,
              name: intl.sendByPhoneConfirm_cancelRequest,
              onTap: () => navigateToRouter(),
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
