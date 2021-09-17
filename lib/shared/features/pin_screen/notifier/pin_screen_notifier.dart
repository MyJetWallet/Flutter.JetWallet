import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../app/shared/components/number_keyboard/number_keyboard.dart';
import '../../../helpers/remove_chars_from.dart';
import '../../../logging/levels.dart';
import '../../../notifiers/user_info_notifier/user_info_notifier.dart';
import '../../../notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../notifiers/user_info_notifier/user_info_state.dart';
import '../../../providers/other/navigator_key_pod.dart';
import '../model/pin_box_enum.dart';
import '../model/pin_flow_union.dart';
import '../view/components/shake_widget/shake_widget.dart';
import 'pin_screen_state.dart';
import 'pin_screen_union.dart';

const pinLength = 4;
const pinBoxAnimationDuration = Duration(milliseconds: 800);
const pinBoxErrorDuration = Duration(milliseconds: 400);

class PinScreenNotifier extends StateNotifier<PinScreenState> {
  PinScreenNotifier(
    this.read,
    this.flowUnion,
  ) : super(
          PinScreenState(
            shakePinKey: GlobalKey<ShakeWidgetState>(),
            shakeTextKey: GlobalKey<ShakeWidgetState>(),
          ),
        ) {
    _initDefaultScreen();
    _userInfo = read(userInfoNotipod);
    _userInfoN = read(userInfoNotipod.notifier);
    _context = read(navigatorKeyPod).currentContext!;
  }

  final Reader read;
  final PinFlowUnion flowUnion;

  static final _logger = Logger('PinScreenNotifier');

  late UserInfoState _userInfo;
  late UserInfoNotifier _userInfoN;
  late BuildContext _context;

  void _initDefaultScreen() {
    flowUnion.when(
      change: () {
        _updateScreenUnion(const EnterPin());
        _updateScreenHeader('Change PIN');
      },
      disable: () {
        _updateScreenUnion(const EnterPin());
        _updateScreenHeader('Enter PIN');
      },
      enable: () {
        _updateScreenUnion(const NewPin());
        _updateScreenHeader('Set PIN');
      },
    );
  }

  void updatePin(String value) {
    if (!_isLengthExceeded(value)) {
      _logger.log(notifier, 'updatePin');

      state.screenUnion.when(
        enterPin: () {
          _updateEnterPin(
            _processInput(state.enterPin, value),
          );
        },
        newPin: () {
          _updateNewPin(
            _processInput(state.newPin, value),
          );
        },
        confirmPin: () {
          _updateConfirmPin(
            _processInput(state.confrimPin, value),
          );
        },
      );

      if (_isPinFilled()) _validatePin();
    }
  }

  void _validatePin() {
    flowUnion.when(
      change: () {
        state.screenUnion.when(
          enterPin: () => _enterPinFlow(disableFlow: false),
          newPin: () => _newPinFlow(),
          confirmPin: () => _confirmPinFlow(),
        );
      },
      disable: () {
        state.screenUnion.when(
          enterPin: () => _enterPinFlow(disableFlow: true),
          newPin: () {}, // not needed
          confirmPin: () {}, // not needed
        );
      },
      enable: () {
        state.screenUnion.when(
          enterPin: () {}, // not needed
          newPin: () => _newPinFlow(),
          confirmPin: () => _confirmPinFlow(),
        );
      },
    );
  }

  Future<void> _enterPinFlow({required bool disableFlow}) async {
    if (state.enterPin != _userInfo.pin) {
      await _errorFlow();
    } else {
      if (disableFlow) {
        await _successFlow(
          _userInfoN.resetPin(),
        );
      } else {
        await _animateCorrect();
        _updateScreenUnion(const NewPin());
      }
    }
  }

  Future<void> _newPinFlow() async {
    await _animateCorrect();
    _updateScreenUnion(const ConfirmPin());
  }

  Future<void> _confirmPinFlow() async {
    if (state.confrimPin != state.newPin) {
      await _errorFlow();
    } else {
      await _successFlow(
        _userInfoN.setPin(state.confrimPin),
      );
    }
  }

  Future<void> _errorFlow() async {
    await _animateError();
    _resetPin();
  }

  Future<void> _successFlow(Future<void> pinAction) async {
    await _animateSuccess();
    await pinAction;
    if (!mounted) return;
    Navigator.pop(_context);
  }

  Future<void> _animateCorrect() async {
    _updatePinBoxState(PinBoxEnum.correct);
    await _waitToShowAnimation(pinBoxErrorDuration);
    _updatePinBoxState(PinBoxEnum.empty);
  }

  Future<void> _animateSuccess() async {
    _updatePinBoxState(PinBoxEnum.success);
    await _waitToShowAnimation();
  }

  Future<void> _animateError() async {
    _updatePinBoxState(PinBoxEnum.error);
    state.shakePinKey.currentState?.shake();
    state.shakeTextKey.currentState?.shake();
    await _waitToShowAnimation(pinBoxErrorDuration);
    _updatePinBoxState(PinBoxEnum.empty);
  }

  void _updatePinBoxState(PinBoxEnum pinState) {
    state = state.copyWith(pinState: pinState);
  }

  void _updateScreenUnion(PinScreenUnion value) {
    state = state.copyWith(screenUnion: value);
  }

  void _updateScreenHeader(String value) {
    state = state.copyWith(screenHeader: value);
  }

  void _updateEnterPin(String value) {
    state = state.copyWith(enterPin: value);
  }

  void _updateNewPin(String value) {
    state = state.copyWith(newPin: value);
  }

  void _updateConfirmPin(String value) {
    state = state.copyWith(confrimPin: value);
  }

  void _resetPin() {
    state.screenUnion.when(
      enterPin: () => _updateEnterPin(''),
      newPin: () => _updateNewPin(''),
      confirmPin: () => _updateConfirmPin(''),
    );
  }

  bool _isPinFilled() {
    return state.screenUnion.when(
      enterPin: () => state.enterPin.length == pinLength,
      newPin: () => state.newPin.length == pinLength,
      confirmPin: () => state.confrimPin.length == pinLength,
    );
  }

  String _processInput(String pin, String value) {
    if (value == backspace) {
      return removeCharsFrom(pin, 1);
    } else {
      if (pin.length > pinLength - 1) return pin;

      return pin + value;
    }
  }

  /// If pin is already filled and keyboard input is not backspace
  bool _isLengthExceeded(String value) {
    if (value != backspace) {
      if (_isPinFilled()) return true;
    }

    return false;
  }

  Future<void> _waitToShowAnimation([Duration? duration]) async {
    await Future.delayed(duration ?? pinBoxAnimationDuration);
  }
}
