import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/pin_screen/model/pin_box_enum.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/pin_screen/store/pin_screen_store.dart';
import 'package:jetwallet/features/pin_screen/ui/widgets/pin_box.dart';
import 'package:jetwallet/features/pin_screen/ui/widgets/shake_widget/shake_widget.dart';
import 'package:jetwallet/widgets/show_verification_modal.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/headers/simple_auth_header.dart';
import 'package:simple_kit/simple_kit.dart';

import '../model/pin_screen_union.dart';

@RoutePage(name: 'PinScreenRoute')
class PinScreen extends StatelessWidget {
  const PinScreen({
    super.key,
    this.displayHeader = true,
    this.cannotLeave = false,
    this.isChangePhone = false,
    this.isConfirmCard = false,
    this.isChangePin = false,
    this.fromRegister = true,
    this.isForgotPassword = false,
    this.alwaysShowForgotPassword = false,
    this.onChangePhone,
    this.onWrongPin,
    this.onError,
    this.onBackPressed,
    this.onVerificationEnd,
    required this.union,
  });

  final bool displayHeader;
  final bool cannotLeave;
  final bool isChangePhone;
  final bool isConfirmCard;
  final bool isChangePin;
  final bool isForgotPassword;
  final bool alwaysShowForgotPassword;
  final Function(String)? onChangePhone;
  final Function(String)? onWrongPin;
  final PinFlowUnion union;
  final Function(String)? onError;
  final bool fromRegister;
  final void Function()? onBackPressed;
  final void Function()? onVerificationEnd;

  @override
  Widget build(BuildContext context) {
    return Provider<PinScreenStore>(
      create: (context) => PinScreenStore(
        union,
        isChangePhone: isChangePhone,
        onChangePhone: onChangePhone,
        isChangePin: isChangePin,
        onWrongPin: onWrongPin,
        onVerificationEnd: onVerificationEnd,
      )..initDefaultScreen(),
      builder: (context, child) => _PinScreenBody(
        displayHeader: displayHeader,
        fromRegister: fromRegister,
        cannotLeave: cannotLeave,
        isChangePhone: isChangePhone,
        isConfirmCard: isConfirmCard,
        isForgotPassword: isForgotPassword,
        alwaysShowForgotPassword: alwaysShowForgotPassword,
        union: union,
        onBackPressed: onBackPressed,
      ),
    );
  }
}

class _PinScreenBody extends StatefulObserverWidget {
  const _PinScreenBody({
    this.displayHeader = true,
    this.cannotLeave = false,
    this.isForgotPassword = false,
    this.isChangePhone = false,
    this.isConfirmCard = false,
    this.alwaysShowForgotPassword = false,
    this.onBackPressed,
    required this.fromRegister,
    required this.union,
  });

  final bool displayHeader;
  final bool cannotLeave;
  final bool isForgotPassword;
  final bool isChangePhone;
  final bool isConfirmCard;
  final bool alwaysShowForgotPassword;
  final PinFlowUnion union;
  final bool fromRegister;
  final void Function()? onBackPressed;

  @override
  State<_PinScreenBody> createState() => _PinScreenBodyState();
}

class _PinScreenBodyState extends State<_PinScreenBody> {
  @override
  Widget build(BuildContext context) {
    final pin = PinScreenStore.of(context);
    final logoutN = getIt.get<LogoutService>();
    final colors = sKit.colors;

    Function()? onbackButton;

    if (!widget.fromRegister) {
      onbackButton = () => Navigator.pop(context);
    } else if (widget.union is Verification) {
      onbackButton = () => logoutN.logout(
            'PIN SCREEN, logout',
            callbackAfterSend: () {},
          );
    } else if (widget.cannotLeave) {
      onbackButton = null;
    } else {
      onbackButton = () => Navigator.pop(context);
    }

    return ReactionBuilder(
      builder: (context) {
        return reaction<PinBoxEnum>(
          (_) => pin.pinState,
          (result) {
            if (result == PinBoxEnum.error) {
              // pin.resetPin();
            } else if (result == PinBoxEnum.empty) {}
          },
          fireImmediately: true,
        );
      },
      child: PopScope(
        canPop: !widget.cannotLeave,
        onPopInvoked: (_) => Future.value(!widget.cannotLeave),
        child: SPageFrame(
          resizeToAvoidBottomInset: false,
          loaderText: intl.register_pleaseWait,
          loading: pin.loader,
          header: Column(
            children: [
              pin.screenUnion.when(
                enterPin: () {
                  if (widget.isChangePhone && !widget.isConfirmCard) {
                    return SLargeHeader(
                      title: intl.pin_screen_confirm_withPin,
                      onBackButtonTap: () {
                        widget.onBackPressed != null ? widget.onBackPressed?.call() : sRouter.maybePop();
                      },
                      titleStyle: sTextH3Style,
                    );
                  }
                  if (widget.isConfirmCard) {
                    return SLargeHeader(
                      title: intl.pin_screen_confirm_withPin,
                      onBackButtonTap: () {
                        widget.onBackPressed != null ? widget.onBackPressed?.call() : sRouter.maybePop();
                      },
                      titleStyle: sTextH4Style,
                      hideBackButton: true,
                      showCloseButton: true,
                    );
                  }

                  return widget.displayHeader
                      ? SLargeHeader(
                          title: pin.screenDescription(),
                          hideBackButton: widget.isForgotPassword,
                        )
                      : const SizedBox();
                },
                confirmPin: () {
                  return SLargeHeader(
                    title: pin.screenDescription(),
                    onBackButtonTap: () {
                      pin.backToNewFlow();

                      onbackButton!();
                    },
                  );
                },
                newPin: () {
                  return SLargeHeader(
                    title: pin.screenDescription(),
                    onBackButtonTap: () {
                      onbackButton!();
                    },
                    customIconButton: SIconButton(
                      onTap: () {
                        if (widget.isForgotPassword) {
                          getIt<LogoutService>().logout(
                            'TWO FA, logout',
                            withLoading: false,
                            callbackAfterSend: () {},
                          );

                          getIt<AppRouter>().maybePop();
                        } else if (!widget.fromRegister) {
                          Navigator.pop(context);
                        } else {
                          showModalVerification(context);
                        }
                      },
                      defaultIcon: const SCloseIcon(),
                      pressedIcon: const SClosePressedIcon(),
                    ),
                  );
                },
              ),
            ],
          ),
          child: Column(
            children: [
              if (!widget.displayHeader)
                Padding(
                  padding: const EdgeInsets.only(
                    top: 64,
                  ),
                  child: Text(
                    intl.pinScreen_enterYourPIN,
                    style: sTextH5Style.copyWith(
                      color: colors.black,
                    ),
                  ),
                ),
              const Spacer(),
              if (pin.isError) ...[
                Text(
                  (pin.screenUnion == const ConfirmPin() || pin.screenUnion == const NewPin())
                      ? intl.pinScreen_pinDontMatch
                      : intl.pinScreen_incorrectPIN,
                  style: sSubtitle3Style.copyWith(color: colors.red),
                ),
                const SpaceH53(),
              ],
              Observer(
                builder: (context) {
                  return ShakeWidget(
                    key: pin.shakePinKey,
                    shakeDuration: pinBoxErrorDuration,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int id = 1; id <= localPinLength; id++)
                          PinBox(
                            state: pin.boxState(id, pin.pinState),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const Spacer(),
              if (widget.alwaysShowForgotPassword ||
                  !widget.displayHeader ||
                  (!widget.isConfirmCard && pin.screenUnion == const PinScreenUnion.enterPin()) ||
                  (widget.isConfirmCard && pin.screenUnion == const PinScreenUnion.enterPin() && pin.showForgot))
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SpaceW24(),
                    Baseline(
                      baselineType: TextBaseline.alphabetic,
                      baseline: 16,
                      child: SClickableLinkText(
                        actualColor: colors.black,
                        onTap: () => sShowAlertPopup(
                          context,
                          primaryText: intl.forgot_pass_confirm_logout,
                          secondaryText: intl.forgot_pass_confirm_logout_desc,
                          primaryButtonName: intl.forgot_pass_logout,
                          image: Image.asset(
                            ellipsisAsset,
                            width: 80,
                            height: 80,
                            package: 'simple_kit',
                          ),
                          onPrimaryButtonTap: () {
                            pin.loader.startLoading();
                            logoutN.logout(
                              'PIN SCREEN',
                              resetPin: true,
                              callbackAfterSend: () {
                                pin.loader.finishLoading();
                              },
                            );
                            Navigator.pop(context);
                          },
                          secondaryButtonName: intl.forgot_pass_dialog_btn_cancel,
                          onSecondaryButtonTap: () {
                            Navigator.pop(context);
                          },
                        ),
                        text: '${intl.pinScreen_forgotYourPin}?',
                      ),
                    ),
                    SBlueRightArrowIcon(
                      color: colors.grey3,
                    ),
                  ],
                )
              else
                const SpaceH24(),
              SNumericKeyboardPin(
                hideBiometricButton: pin.hideBiometricButton,
                onKeyPressed: (value) async {
                  await pin.updatePin(value).then(
                        (value) => setState(() {
                          HapticFeedback.lightImpact();
                        }),
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
