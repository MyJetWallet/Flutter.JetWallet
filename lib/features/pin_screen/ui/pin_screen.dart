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
import 'package:jetwallet/utils/biometric/biometric_tools.dart';
import 'package:jetwallet/widgets/show_verification_modal.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
  void initState() {
    super.initState();
    getBiometricStatus();
  }

  NumericKeyboardType keyboardType = NumericKeyboardType.none;

  Future<void> getBiometricStatus() async {
    try {
      final pin = PinScreenStore.of(context);
      final biometricStatusData = await biometricStatus();

      setState(() {
        if (pin.hideBiometricButton) {
          keyboardType = NumericKeyboardType.none;
        } else {
          keyboardType = _keyboardTypeBasedOnBiometricStatus(biometricStatusData);
        }
      });
    } catch (e) {
      setState(() {
        keyboardType = NumericKeyboardType.none;
      });
    }
  }

  NumericKeyboardType _keyboardTypeBasedOnBiometricStatus(BiometricStatus bioStatus) {
    if (bioStatus == BiometricStatus.face) {
      return NumericKeyboardType.fasceId;
    } else if (bioStatus == BiometricStatus.fingerprint) {
      return NumericKeyboardType.touchId;
    } else {
      return NumericKeyboardType.none;
    }
  }

  @override
  Widget build(BuildContext context) {
    final pin = PinScreenStore.of(context);
    final logoutN = getIt.get<LogoutService>();
    final colors = SColorsLight();

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
        return reaction<PinScreenUnion>(
          (_) => pin.screenUnion,
          (result) {
            if (result == const PinScreenUnion.newPin()) {
              sAnalytics.signInFlowCreatePinView();
            }
            if (result == const PinScreenUnion.confirmPin()) {
              sAnalytics.signInFlowConfirmPinView();
            }
          },
          fireImmediately: true,
        );
      },
      child: ReactionBuilder(
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
          onPopInvokedWithResult: (_, __) => Future.value(!widget.cannotLeave),
          child: SPageFrame(
            resizeToAvoidBottomInset: false,
            loaderText: intl.register_pleaseWait,
            loading: pin.loader,
            header: Column(
              children: [
                pin.screenUnion.when(
                  enterPin: () {
                    if (widget.isChangePhone && !widget.isConfirmCard) {
                      return SimpleLargeAppbar(
                        title: intl.pin_screen_confirm_withPin,
                        onLeftIconTap: () {
                          widget.onBackPressed != null ? widget.onBackPressed?.call() : sRouter.maybePop();
                        },
                      );
                    }
                    if (widget.isConfirmCard) {
                      return SimpleLargeAppbar(
                        title: intl.pin_screen_confirm_withPin,
                        onRightIconTap: () {
                          widget.onBackPressed != null ? widget.onBackPressed?.call() : sRouter.maybePop();
                        },
                        hasLeftIcon: false,
                        hasRightIcon: true,
                      );
                    }

                    return widget.displayHeader
                        ? SimpleLargeAppbar(
                            title: pin.screenDescription(),
                            hasLeftIcon: !widget.isForgotPassword,
                          )
                        : const SizedBox();
                  },
                  confirmPin: () {
                    return SimpleLargeAppbar(
                      title: pin.screenDescription(),
                      onLeftIconTap: () {
                        pin.backToNewFlow();

                        onbackButton!();
                      },
                    );
                  },
                  newPin: () {
                    return SimpleLargeAppbar(
                      title: pin.screenDescription(),
                      leftIcon: SafeGesture(
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
                        child: const SCloseIcon(),
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
                      style: STStyles.header6.copyWith(
                        color: colors.black,
                      ),
                    ),
                  ),
                const Spacer(),
                if (pin.isError) ...[
                  Text(
                    (pin.screenUnion == const ConfirmPin() || pin.screenUnion == const NewPin())
                        ? intl.pinScreen_pinDontMatch
                        : pin.error != null && pin.error == 'WrongPinCodeBlocked'
                            ? intl.pinScreen_tryAgainLater
                            : intl.pinScreen_incorrectPIN,
                    style: STStyles.subtitle2.copyWith(color: colors.red),
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
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SHyperlink(
                          text: '${intl.pinScreen_forgotYourPin}?',
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
                        ),
                      ],
                    ),
                  )
                else
                  const SpaceH24(),
                SNumericKeyboard(
                  type: keyboardType,
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
      ),
    );
  }
}
