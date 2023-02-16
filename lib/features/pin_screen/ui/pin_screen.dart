import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/pin_screen/model/pin_box_enum.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/pin_screen/store/pin_screen_store.dart';
import 'package:jetwallet/features/pin_screen/ui/widgets/pin_box.dart';
import 'package:jetwallet/features/pin_screen/ui/widgets/shake_widget/shake_widget.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/headers/simple_auth_header.dart';
import 'package:simple_kit/simple_kit.dart';

class PinScreen extends StatelessWidget {
  const PinScreen({
    Key? key,
    this.displayHeader = true,
    this.cannotLeave = false,
    this.isChangePhone = false,
    this.onChangePhone,
    required this.union,
  }) : super(key: key);

  final bool displayHeader;
  final bool cannotLeave;
  final bool isChangePhone;
  final Function(String)? onChangePhone;
  final PinFlowUnion union;

  @override
  Widget build(BuildContext context) {
    return Provider<PinScreenStore>(
      create: (context) => PinScreenStore(
        union,
        isChangePhone: isChangePhone,
        onChangePhone: onChangePhone,
      ),
      builder: (context, child) => _PinScreenBody(
        displayHeader: displayHeader,
        cannotLeave: cannotLeave,
        union: union,
      ),
    );
  }
}

class _PinScreenBody extends StatefulObserverWidget {
  const _PinScreenBody({
    Key? key,
    this.displayHeader = true,
    this.cannotLeave = false,
    required this.union,
  }) : super(key: key);

  final bool displayHeader;
  final bool cannotLeave;
  final PinFlowUnion union;

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

    if (widget.union is Verification || widget.union is Setup) {
      onbackButton = () => logoutN.logout('PIN SCREEN, logout');
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
              pin.resetPin();
            } else if (result == PinBoxEnum.empty) {}
          },
          fireImmediately: true,
        );
      },
      child: WillPopScope(
        onWillPop: () => Future.value(!widget.cannotLeave),
        child: SPageFrame(
          loaderText: intl.register_pleaseWait,
          loading: pin.loader,
          header: Column(
            children: [
              pin.screenUnion.when(
                enterPin: () {
                  return widget.displayHeader
                      ? SAuthHeader(title: pin.screenDescription())
                      : const SizedBox();
                },
                confirmPin: () {
                  return SAuthHeader(
                    title: pin.screenDescription(),
                    progressValue: 100,
                    onBackButtonTap: () {
                      onbackButton!();
                    },
                  );
                },
                newPin: () {
                  return SAuthHeader(
                    title: pin.screenDescription(),
                    progressValue: 100,
                    onBackButtonTap: () {
                      onbackButton!();
                    },
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
              if (!widget.displayHeader || pin.showForgot)
                InkWell(
                  highlightColor: colors.grey5,
                  onTap: () => sShowAlertPopup(
                    context,
                    primaryText: intl.forgot_pass_dialog_title,
                    secondaryText: intl.forgot_pass_dialog_text,
                    primaryButtonType: SButtonType.primary3,
                    primaryButtonName: intl.forgot_pass_dialog_btn_reset,
                    image: Image.asset(
                      ellipsisAsset,
                      width: 80,
                      height: 80,
                      package: 'simple_kit',
                    ),
                    onPrimaryButtonTap: () {
                      logoutN.logout('PIN SCREEN', resetPin: true);
                      Navigator.pop(context);
                    },
                    secondaryButtonName: intl.forgot_pass_dialog_btn_cancel,
                    onSecondaryButtonTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: colors.black,
                        ),
                      ),
                    ),
                    child: Baseline(
                      baselineType: TextBaseline.alphabetic,
                      baseline: 22,
                      child: Text(
                        '${intl.pinScreen_forgotYourPin}?',
                        style: sBodyText2Style,
                      ),
                    ),
                  ),
                ),
              if (!widget.displayHeader) const SpaceH34(),
              if (widget.displayHeader) const SpaceH40(),
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
