import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/crypto_card/widgets/crypto_card_your_pin_widget.dart';
import 'package:jetwallet/features/pin_screen/model/pin_box_enum.dart';
import 'package:jetwallet/features/pin_screen/ui/widgets/shake_widget/shake_widget.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/change_pin_crypto_card_request_model.dart';

part 'change_pin_crypto_card_store.g.dart';

const String _tag = 'ChangePinCryptoCardStore';

const pinBoxErrorDuration = Duration(milliseconds: 400);

enum _ChangePinCryptoCardFlowState {
  enterPin,
  confirmPin,
}

class ChangePinCryptoCardStore extends _ChangePinCryptoCardStoreBase with _$ChangePinCryptoCardStore {
  ChangePinCryptoCardStore() : super();

  _ChangePinCryptoCardStoreBase of(BuildContext context) => Provider.of<ChangePinCryptoCardStore>(context);
}

abstract class _ChangePinCryptoCardStoreBase with Store {
  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  _ChangePinCryptoCardFlowState state = _ChangePinCryptoCardFlowState.enterPin;

  @computed
  bool get isConfirmPinFlow => state == _ChangePinCryptoCardFlowState.confirmPin;

  @observable
  String enterPin = '';

  @observable
  String confirmPin = '';

  @observable
  ObservableList<PinBoxEnum> pinStates = ObservableList.of(
    [
      PinBoxEnum.empty,
      PinBoxEnum.empty,
      PinBoxEnum.empty,
      PinBoxEnum.empty,
    ],
  );

  @observable
  String? error;

  @observable
  GlobalKey<ShakeWidgetState> shakePinKey = GlobalKey<ShakeWidgetState>();

  @action
  void updatePin(String value) {
    void ifFullPinFlow() {
      Future.delayed(
        const Duration(milliseconds: 300),
        () {
          validatePin();
        },
      );
    }

    try {
      if (value == 'backspace') {
        error = null;

        if (state == _ChangePinCryptoCardFlowState.enterPin) {
          if (enterPin.isNotEmpty) {
            enterPin = enterPin.substring(0, enterPin.length - 1);
          }
        } else {
          if (confirmPin.isNotEmpty) {
            confirmPin = confirmPin.substring(0, confirmPin.length - 1);
          }
        }
      } else {
        if (state == _ChangePinCryptoCardFlowState.enterPin) {
          if (enterPin.length == 4) {
            return;
          }
          error = null;
          enterPin += value;
          if (enterPin.length == 4) {
            ifFullPinFlow();
          }
        } else {
          if (confirmPin.length == 4) {
            return;
          }
          error = null;
          confirmPin += value;
          if (confirmPin.length == 4) {
            ifFullPinFlow();
          }
        }
      }

      updatePinStatus();
    } catch (error) {
      logError(
        message: 'Update pin: $error',
      );
    }
  }

  void validatePin() {
    void validPinFlow() {
      pinStates.clear();
      pinStates.addAll(
        List.filled(
          4,
          PinBoxEnum.success,
        ),
      );
    }

    void invalidPinFlow() {
      pinStates.clear();
      pinStates.addAll(
        List.filled(
          4,
          PinBoxEnum.error,
        ),
      );
      shakePinKey.currentState?.shake();
    }

    if (state == _ChangePinCryptoCardFlowState.enterPin) {
      final result = validateIfPinIsStrong();
      if (result) {
        validPinFlow();
        Future.delayed(
          const Duration(milliseconds: 300),
          () {
            state = _ChangePinCryptoCardFlowState.confirmPin;
            sAnalytics.viewConfirmPINScreen();
            updatePinStatus();
          },
        );
      } else {
        error = intl.crypto_card_pin_not_strong;
        invalidPinFlow();
      }
    } else {
      if (enterPin == confirmPin) {
        setNewPin();
      } else {
        error = intl.crypto_card_pin_does_not_match;
        invalidPinFlow();
      }
    }
  }

  bool validateIfPinIsStrong() {
    return true;
  }

  void updatePinStatus() {
    PinBoxEnum getPinStatusByIdAndPin({
      required int id,
      required String pin,
    }) {
      if (id <= pin.length) {
        return PinBoxEnum.filled;
      } else {
        return PinBoxEnum.empty;
      }
    }

    if (error != null) {
      pinStates.clear();
      pinStates.addAll(
        List.filled(
          4,
          PinBoxEnum.error,
        ),
      );
    }

    if (state == _ChangePinCryptoCardFlowState.enterPin) {
      pinStates.clear();
      pinStates.addAll(
        List.generate(
          4,
          (index) => getPinStatusByIdAndPin(
            id: index + 1,
            pin: enterPin,
          ),
        ),
      );
    } else {
      pinStates.clear();
      pinStates.addAll(
        List.generate(
          4,
          (index) => getPinStatusByIdAndPin(
            id: index + 1,
            pin: confirmPin,
          ),
        ),
      );
    }
  }

  @action
  Future<void> setNewPin() async {
    void setInvalidPinState() {
      pinStates.clear();
      pinStates.addAll(
        List.filled(
          4,
          PinBoxEnum.error,
        ),
      );
    }

    loader.startLoadingImmediately();
    try {
      final model = ChangePinCryptoCardRequestModel(
        cardId: sSignalRModules.cryptoCardProfile.cards.first.cardId,
        pin: enterPin,
      );

      final response = await sNetwork.getWalletModule().changePinCryptoCard(model);

      if (response.hasError) {
        setInvalidPinState();

        sNotification.showError(
          response.error!.cause,
          id: 1,
        );
      } else {
        pinStates.clear();
        pinStates.addAll(
          List.filled(
            4,
            PinBoxEnum.success,
          ),
        );

        sAnalytics.viewPINSuccessScreen();

        await sRouter.push(
          SuccessScreenRouter(
            secondaryText: intl.crypto_card_change_pin_success,
            time: 8,
            isCryptoCardChangePinFlow: true,
            child: CryptoCardYourPinWidget(
              pin: enterPin,
            ),
            onCloseButton: () {
              sAnalytics.tapDonePINChange();
            },
          ),
        );
      }
    } on ServerRejectException catch (error) {
      setInvalidPinState();

      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      setInvalidPinState();

      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
      );
      logError(
        message: 'setNewPin error: $error',
      );
    }
    loader.finishLoadingImmediately();
  }

  void logError({required String message}) {
    getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: _tag,
          message: message,
        );
  }
}
