import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/startup_service.dart';
import 'package:jetwallet/core/services/user_info/models/user_info.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/pin_screen/model/pin_box_enum.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/pin_screen/model/pin_screen_union.dart';
import 'package:jetwallet/features/pin_screen/ui/widgets/shake_widget/shake_widget.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/auth_api/models/check_pin/check_pin_response_model.dart';

part 'pin_screen_store.g.dart';

const pinBoxAnimationDuration = Duration(milliseconds: 800);
const pinBoxErrorDuration = Duration(milliseconds: 400);

class PinScreenStore extends _PinScreenStoreBase with _$PinScreenStore {
  PinScreenStore(PinFlowUnion flowUnionflowUnion) : super(flowUnionflowUnion);

  static _PinScreenStoreBase of(BuildContext context) =>
      Provider.of<PinScreenStore>(context, listen: false);
}

abstract class _PinScreenStoreBase with Store {
  _PinScreenStoreBase(this.flowUnion) {
    _initDefaultScreen();
  }

  final PinFlowUnion flowUnion;

  static final _logger = Logger('PinScreenStore');

  final UserInfoState _userInfo = sUserInfo.userInfo;
  final UserInfoService _userInfoN = sUserInfo;

  int attemptsLeft = maxPinAttempts;

  @observable
  bool hideBiometricButton = true;

  @observable
  String screenHeader = '';

  /// Pin that needs to match current userPin
  @observable
  String enterPin = '';

  /// New pin that user want to set
  @observable
  String newPin = '';

  /// Pin that needs to match newPin
  @observable
  String confrimPin = '';

  /// Where we currently are in the PIN flow
  @observable
  PinScreenUnion screenUnion = const PinScreenUnion.enterPin();

  /// How to animate pinState
  @observable
  PinBoxEnum pinState = PinBoxEnum.empty;

  @observable
  int lockTime = 0;

  @observable
  GlobalKey<ShakeWidgetState> shakePinKey = GlobalKey<ShakeWidgetState>();

  @observable
  GlobalKey<ShakeWidgetState> shakeTextKey = GlobalKey<ShakeWidgetState>();

  @observable
  ObservableList<String> confirmPin = ObservableList.of([]);

  @action
  PinBoxEnum boxState(int boxId, PinBoxEnum state) {
    return screenUnion.when(
      enterPin: () => _boxState(enterPin, boxId, state),
      newPin: () => _boxState(newPin, boxId, state),
      confirmPin: () => _boxState(confrimPin, boxId, state),
    );
  }

  @action
  PinBoxEnum _boxState(String pin, int boxId, PinBoxEnum state) {
    if (state == PinBoxEnum.correct) return state;
    if (state == PinBoxEnum.success) return state;
    if (state == PinBoxEnum.error) return state;

    return pin.length >= boxId ? PinBoxEnum.filled : PinBoxEnum.empty;
  }

  @action
  Future<void> _initDefaultScreen() async {
    final bioStatus = await biometricStatus();
    final hideBio = bioStatus == BiometricStatus.none;

    await flowUnion.when(
      change: () async {
        await _initFlowThatStartsFromEnterPin(
          intl.pinScreen_changePin,
          hideBio,
        );
      },
      disable: () async {
        await _initFlowThatStartsFromEnterPin(intl.pinScreen_enterPin, hideBio);
      },
      enable: () {
        _updateScreenUnion(const NewPin());
        _updateScreenHeader(intl.pinScreen_setPin);
      },
      verification: () async {
        await _initFlowThatStartsFromEnterPin(intl.pinScreen_enterPin, hideBio);
      },
      setup: () {
        _updateScreenUnion(const NewPin());
        _updateScreenHeader(intl.pinScreen_setPin);
      },
    );
  }

  @action
  Future<void> _initFlowThatStartsFromEnterPin(
    String title,
    bool hideBio,
  ) async {
    _updateScreenUnion(const EnterPin());
    _updateScreenHeader(title);
    _updateHideBiometricButton(hideBio);

    final storageService = sLocalStorageService;
    final usingBio = await storageService.getValue(useBioKey);
    if (usingBio == true.toString() && _userInfo.pin != null) {
      await updatePin(await _authenticateWithBio());
    }
  }

  @action
  Future<void> updatePin(String value) async {
    if (!_isLengthExceeded(value)) {
      _logger.log(notifier, 'updatePin');

      await screenUnion.when(
        enterPin: () async {
          _updateEnterPin(
            await _processInput(enterPin, value),
          );
        },
        newPin: () async {
          _updateNewPin(
            await _processInput(newPin, value),
          );
        },
        confirmPin: () async {
          _updateConfirmPin(
            await _processInput(confrimPin, value),
          );
        },
      );

      if (_isPinFilled()) await _validatePin();
    }
  }

  @action
  Future<void> _validatePin() async {
    await flowUnion.when(
      change: () async {
        await screenUnion.when(
          enterPin: () => _enterPinFlow(),
          newPin: () => _changePinFlow(),
          confirmPin: () => {},
        );
      },
      disable: () async {
        await screenUnion.maybeWhen(
          enterPin: () => _enterPinFlow(),
          orElse: () {},
        );
      },
      enable: () async {
        await screenUnion.when(
          enterPin: () {}, // not needed
          newPin: () => _newPinFlow(),
          confirmPin: () => _confirmPinFlow(),
        );
      },
      verification: () async {
        await screenUnion.maybeWhen(
          enterPin: () => _enterPinFlow(),
          orElse: () {},
        );
      },
      setup: () async {
        await screenUnion.when(
          enterPin: () {}, // not needed
          newPin: () => _newPinFlow(),
          confirmPin: () => _confirmPinFlow(),
        );
      },
    );
  }

  @action
  Future<void> _enterPinFlow() async {
    try {
      final response = await sNetwork.getAuthModule().postCheckPin(enterPin);

      if (response.hasError) {
        await _errorFlow();
      }

      response.pick(
        onData: (data) async {
          await flowUnion.maybeWhen(
            disable: () async {
              await _userInfoN.disablePin();

              await _successFlow(
                _userInfoN.resetPin(),
              );
            },
            verification: () async {
              await _animateSuccess();

              await _userInfoN.setPin(enterPin);
              if (_userInfo.isJustLogged) {
                getIt.get<StartupService>().pinSet();
              } else {
                getIt.get<StartupService>().pinVerified();
              }
            },
            orElse: () async {
              await _animateCorrect();

              _updateHideBiometricButton(true);
              _updateScreenUnion(const NewPin());
            },
          );
        },
        onError: (ServerRejectException error) async {
          if (error.cause == 'InvalidCode') {
            await _errorFlow();
            _updateNewPin('');
            _updateConfirmPin('');

            await resetPin();

            if (attemptsLeft > 1) {
              attemptsLeft--;
              sNotification.showError(
                'The PIN you entered is incorrect,$attemptsLeft attempts remaining.',
              );
              _updateNewPin('');
              _updatePinBoxState(PinBoxEnum.empty);
            } else {
              sNotification.showError(
                'Incorrect PIN has been entered more than $maxPinAttempts times, '
                'you have been logged out of your account.',
                duration: 5,
              );

              await getIt.get<LogoutService>().logout();
            }

            await resetPin();
          } else {
            sNotification.showError(error.cause);
          }
        },
      );
    } catch (e) {
      await _errorFlow();

      sNotification.showError(
        e.toString(),
        id: 1,
      );
    }
  }

  @action
  Future<void> _newPinFlow() async {
    Future<void> _success() async {
      await _animateCorrect();
      _updateScreenUnion(const ConfirmPin());
    }

    try {
      _updateConfirmPin('');
      await _success();
    } catch (e) {
      _updateNewPin('');
    }
  }

  @action
  Future<void> _confirmPinFlow() async {
    try {
      if (newPin == confrimPin) {
        final response = await sNetwork.getAuthModule().postSetupPin(newPin);

        if (response.error != null) {
          await _animateError();
          _updateNewPin('');
          _updateConfirmPin('');
          _updateScreenUnion(const NewPin());

          return;
        }
        await _animateCorrect(isConfirm: true);
        await _userInfoN.setPin(confrimPin);
        getIt.get<StartupService>().pinSet();
      } else {
        await _animateError();
        _updateNewPin('');
        _updateConfirmPin('');
        _updateScreenUnion(const NewPin());
      }
    } catch (e) {
      await _animateError();
      _updateNewPin('');
      _updateConfirmPin('');
      _updateScreenUnion(const NewPin());
    }
  }

  @action
  Future<void> _changePinFlow() async {
    try {
      final response = await sNetwork.getAuthModule().postChangePin(
            enterPin,
            newPin,
          );

      if (response.hasError) {
        sNotification.showError(
          response.error?.cause ?? '',
          id: 1,
        );

        return;
      }

      await _animateCorrect();
      await _userInfoN.setPin(newPin);
      _updateNewPin('');
      await _successFlow(
        _userInfoN.setPin(newPin),
      );
    } catch (e) {
      _updateNewPin('');
    }
  }

  @action
  Future<void> _errorFlow() async {
    await _animateError();
    await resetPin();
  }

  @action
  Future<void> _successFlow(Future<void> pinAction) async {
    await _animateSuccess();
    await pinAction;

    await sRouter.pop();
  }

  @action
  Future<void> _animateCorrect({
    bool isConfirm = false,
  }) async {
    if (isConfirm) {
      _updatePinBoxState(PinBoxEnum.success);
    } else {
      _updatePinBoxState(PinBoxEnum.correct);
    }
    await _waitToShowAnimation(pinBoxErrorDuration);
    _updatePinBoxState(PinBoxEnum.empty);
  }

  @action
  Future<void> _animateSuccess() async {
    _updatePinBoxState(PinBoxEnum.success);
    await _waitToShowAnimation();
  }

  @action
  Future<void> _animateError() async {
    _updatePinBoxState(PinBoxEnum.error);

    shakePinKey.currentState?.shake();
    shakeTextKey.currentState?.shake();

    await _waitToShowAnimation(pinBoxErrorDuration);
    _updatePinBoxState(PinBoxEnum.empty);
  }

  @action
  void _updatePinBoxState(PinBoxEnum _pinState) {
    pinState = _pinState;
  }

  @action
  void _updateScreenUnion(PinScreenUnion value) {
    screenUnion = value;
  }

  @action
  void _updateScreenHeader(String value) {
    screenHeader = value;
  }

  @action
  void _updateEnterPin(String value) {
    enterPin = value;
  }

  @action
  void _updateNewPin(String value) {
    newPin = value;
  }

  @action
  void _updateConfirmPin(String value) {
    confrimPin = value;
  }

  @action
  void _updateHideBiometricButton(bool value) {
    hideBiometricButton = _userInfo.pin == null ? true : value;
  }

  @action
  Future<void> resetPin() async {
    newPin = '';
    enterPin = '';
    confrimPin = '';
    screenUnion.when(
      enterPin: () => _updateEnterPin(''),
      newPin: () => _updateNewPin(''),
      confirmPin: () => _updateConfirmPin(''),
    );
  }

  @action
  bool _isPinFilled() {
    return screenUnion.when(
      enterPin: () => enterPin.length == localPinLength,
      newPin: () => newPin.length == localPinLength,
      confirmPin: () => confrimPin.length == localPinLength,
    );
  }

  @action
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
  @action
  bool _isLengthExceeded(String value) {
    if (value != backspace) {
      if (_isPinFilled()) return true;
    }

    return false;
  }

  @action
  Future<void> _waitToShowAnimation([Duration? duration]) async {
    await Future.delayed(duration ?? pinBoxAnimationDuration);
  }

  @action
  Future<String> _authenticateWithBio() async {
    final success = await makeAuthWithBiometrics(
      intl.pinScreen_weNeedYouToConfirmYourIdentity,
    );

    return success ? _userInfo.pin ?? '' : '';
  }

  @action
  String screenDescription() {
    return screenUnion.when(
      enterPin: () {
        return intl.pinScreen_enterYourPIN;
      },
      newPin: () {
        return intl.pin_screen_set_new_pin;
      },
      confirmPin: () {
        return intl.pin_screen_confirm_newPin;
      },
    );
  }
}
