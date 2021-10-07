import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../app/shared/components/number_keyboard/key_constants.dart';
import '../../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../../helpers/biometrics_auth_helpers.dart';
import '../../../helpers/remove_chars_from.dart';
import '../../../logging/levels.dart';
import '../../../notifiers/user_info_notifier/user_info_notifier.dart';
import '../../../notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../notifiers/user_info_notifier/user_info_state.dart';
import '../../../providers/other/navigator_key_pod.dart';
import '../../../services/remote_config_service/remote_config_values.dart';
import '../model/pin_box_enum.dart';
import '../model/pin_flow_union.dart';
import '../model/pin_lock_enum.dart';
import '../view/components/shake_widget/shake_widget.dart';
import 'pin_screen_state.dart';
import 'pin_screen_union.dart';

const pinBoxAnimationDuration = Duration(milliseconds: 800);
const pinBoxErrorDuration = Duration(milliseconds: 400);
const defaultEnterPinAttempts = 5;

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

  /// Attempts on every stage of the PinLock
  int _enterPinAttempts = defaultEnterPinAttempts;
  Timer _timer = Timer(Duration.zero, () {});

  Future<void> _initDefaultScreen() async {
    final bioStatus = await biometricStatus();
    final hideBio = bioStatus == BiometricStatus.none;

    await flowUnion.when(
      change: () async {
        await _initFlowThatStartsFromEnterPin('Change PIN', hideBio);
      },
      disable: () async {
        await _initFlowThatStartsFromEnterPin('Enter PIN', hideBio);
      },
      enable: () {
        _updateScreenUnion(const NewPin());
        _updateScreenHeader('Set PIN');
      },
      verification: () async {
        await _initFlowThatStartsFromEnterPin('Enter PIN', hideBio);
      },
      setup: () {
        _updateScreenUnion(const NewPin());
        _updateScreenHeader('Set PIN');
      },
    );
  }

  Future<void> _initFlowThatStartsFromEnterPin(
    String title,
    bool hideBio,
  ) async {
    _updateScreenUnion(const EnterPin());
    _updateScreenHeader(title);
    _updateHideBiometricButton(hideBio);
    await updatePin(await _authenticateWithBio());
  }

  Future<void> updatePin(String value) async {
    if (!_isLengthExceeded(value)) {
      _logger.log(notifier, 'updatePin');

      await state.screenUnion.when(
        enterPin: () async {
          _updateEnterPin(
            await _processInput(state.enterPin, value),
          );
        },
        newPin: () async {
          _updateNewPin(
            await _processInput(state.newPin, value),
          );
        },
        confirmPin: () async {
          _updateConfirmPin(
            await _processInput(state.confrimPin, value),
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
          enterPin: () => _enterPinFlow(),
          newPin: () => _newPinFlow(),
          confirmPin: () => _confirmPinFlow(),
        );
      },
      disable: () {
        state.screenUnion.maybeWhen(
          enterPin: () => _enterPinFlow(),
          orElse: () {},
        );
      },
      enable: () {
        state.screenUnion.when(
          enterPin: () {}, // not needed
          newPin: () => _newPinFlow(),
          confirmPin: () => _confirmPinFlow(),
        );
      },
      verification: () {
        state.screenUnion.maybeWhen(
          enterPin: () => _enterPinFlow(),
          orElse: () {},
        );
      },
      setup: () {
        state.screenUnion.when(
          enterPin: () {}, // not needed
          newPin: () => _newPinFlow(),
          confirmPin: () => _confirmPinFlow(),
        );
      },
    );
  }

  Future<void> _enterPinFlow() async {
    if (state.enterPin != _userInfo.pin) {
      await _errorFlow();
      _enterPinAttempts--;
      if (_enterPinAttempts <= 0) {
        _nextPinLock();
      }
    } else {
      await flowUnion.maybeWhen(
        disable: () async {
          await _successFlow(
            _userInfoN.resetPin(),
          );
        },
        verification: () async {
          await _animateSuccess();
          read(startupNotipod.notifier).pinVerified();
        },
        orElse: () async {
          await _animateCorrect();
          _updateHideBiometricButton(true);
          _updateScreenUnion(const NewPin());
        },
      );
    }
  }

  Future<void> _newPinFlow() async {
    await _animateCorrect();
    _updateScreenUnion(const ConfirmPin());
  }

  Future<void> _confirmPinFlow() async {
    if (state.confrimPin != state.newPin) {
      await _errorFlow();
      _updateNewPin('');
      _updateScreenUnion(const NewPin());
    } else {
      await flowUnion.maybeWhen(
        setup: () async {
          await _animateSuccess();
          await _userInfoN.setPin(state.confrimPin);
          read(startupNotipod.notifier).pinSet();
        },
        orElse: () async {
          await _successFlow(
            _userInfoN.setPin(state.confrimPin),
          );
        },
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

  void _updateHideBiometricButton(bool value) {
    state = state.copyWith(hideBiometricButton: value);
  }

  void _updatePinLock(PinLockEnum value) {
    state = state.copyWith(pinLock: value);
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
      enterPin: () => state.enterPin.length == localPinLength,
      newPin: () => state.newPin.length == localPinLength,
      confirmPin: () => state.confrimPin.length == localPinLength,
    );
  }

  Future<String> _processInput(String pin, String value) async {
    if (value == face || value == fingerprint) {
      return _authenticateWithBio();
    } else if (value == backspace) {
      return removeCharsFrom(pin, 1);
    } else {
      if (pin.length > localPinLength - 1) return pin;

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

  Future<String> _authenticateWithBio() async {
    final success = await makeAuthWithBiometrics();

    if (success) {
      return _userInfo.pin ?? '';
    } else {
      return '';
    }
  }

  /// Increases lock time
  void _nextPinLock() {
    final length = PinLockEnum.values.length;
    final index = state.pinLock.index;

    if (index < length - 1) {
      _updatePinLock(PinLockEnum.values[index + 1]);
      _startLockTimer(state.pinLock.seconds);
    } else {
      _startLockTimer(state.pinLock.seconds);
    }
  }

  void _startLockTimer(int initial) {
    _timer.cancel();
    state = state.copyWith(lockTime: initial);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.lockTime == 0) {
          _enterPinAttempts = defaultEnterPinAttempts;
          timer.cancel();
        } else {
          state = state.copyWith(
            lockTime: state.lockTime - 1,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
