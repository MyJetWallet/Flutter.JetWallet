import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../model/pin_box_enum.dart';
import '../view/components/shake_widget/shake_widget.dart';
import 'pin_screen_union.dart';

part 'pin_screen_state.freezed.dart';

@freezed
class PinScreenState with _$PinScreenState {
  const factory PinScreenState({
    @Default(true) bool hideBiometricButton,
    @Default('') String screenHeader,

    /// Pin that needs to match current userPin
    @Default('') String enterPin,

    /// New pin that user want to set
    @Default('') String newPin,

    /// Pin that needs to match newPin
    @Default('') String confrimPin,

    /// Where we currently are in the PIN flow
    @Default(EnterPin()) PinScreenUnion screenUnion,

    /// How to animate pinState
    @Default(PinBoxEnum.empty) PinBoxEnum pinState,

    /// in seconds. if lockTime > 0; block input
    @Default(0) int lockTime,
    required GlobalKey<ShakeWidgetState> shakePinKey,
    required GlobalKey<ShakeWidgetState> shakeTextKey,
  }) = _PinScreenState;

  const PinScreenState._();

  PinBoxEnum boxState(int boxId) {
    return screenUnion.when(
      enterPin: () => _boxState(enterPin, boxId),
      newPin: () => _boxState(newPin, boxId),
      confirmPin: () => _boxState(confrimPin, boxId),
    );
  }

  PinBoxEnum _boxState(String pin, int boxId) {
    if (pinState == PinBoxEnum.correct) return pinState;
    if (pinState == PinBoxEnum.success) return pinState;
    if (pinState == PinBoxEnum.error) return pinState;
    if (pin.length >= boxId) {
      return PinBoxEnum.filled;
    } else {
      return PinBoxEnum.empty;
    }
  }
}
