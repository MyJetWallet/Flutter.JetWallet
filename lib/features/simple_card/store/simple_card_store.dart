import 'dart:convert';
import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:openpgp/openpgp.dart';
import 'package:simple_kit/modules/shared/simple_show_alert_popup.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_remind_pin_response.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_sensitive_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_sevsitive_response.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/services/rsa_service.dart';
import '../../../utils/constants.dart';
import '../ui/set_up_password_screen.dart';

part 'simple_card_store.g.dart';

@lazySingleton
class SimpleCardStore = _SimpleCardStoreBase with _$SimpleCardStore;


abstract class _SimpleCardStoreBase with Store {

  @observable
  StackLoaderStore loader = StackLoaderStore();

  final storageService = getIt.get<LocalStorageService>();

  @action
  Future<void> initStore() async {
    final cards = sSignalRModules.bankingProfileData?.banking?.cards;
    if (cards != null && cards.isNotEmpty) {
      print('cards[0]');
      print(cards[0]);
      setCardFullInfo(cards[0]);
      isFrozen = cards[0].status == AccountStatusCard.frozen;

      final rsaService = getIt.get<RsaService>();

      // try {
      //   rsaService.init();
      //   await rsaService.savePrivateKey(storageService);
      //   final publicKey = rsaService.publicKey;
      //   final model = SimpleCardSensitiveRequest(
      //     // cardId: cards[0].cardId ?? '',
      //     cardId: '9a4be417-b5ca-458c-a5c2-6442530875e2',
      //     publicKey: publicKey
      //         .replaceAll('\r\n', '')
      //         .replaceAll('-----BEGIN RSA PUBLIC KEY-----', '')
      //         .replaceAll('-----END RSA PUBLIC KEY-----', ''),
      //   );
      //   print('error model');
      //   print(model);
      //
      //   final response =
      //       await sNetwork.getWalletModule().postSensitiveData(data: model);
      //
      //   response.pick(
      //     onData: (data) async {
      //       print('error data');
      //       log('$data');
      //       final cardNumber = rsaService.sign(
      //         data.cardNumber!,
      //         rsaService.privateKey,
      //       );
      //       log('${rsaService.privateKey}');
      //       final base64Decoded = base64Decode(data.cardNumber!);
      //       final utf8Decoded = utf8.decode(base64Decoded);
      //       print(utf8Decoded);
      //       final encrypted = await OpenPGP.decrypt(
      //         utf8Decoded,
      //         rsaService.privateKey,
      //         'cardnumber'
      //       );
      //       print('decrypted');
      //       print(encrypted);
      //       print(cardNumber);
      //     },
      //     onError: (error) {
      //       print('error 1');
      //       print(error);
      //       sNotification.showError(
      //         error.cause,
      //         id: 1,
      //       );
      //     },
      //   );
      // } on ServerRejectException catch (error) {
      //   print('error 2');
      //   print(error);
      //   sNotification.showError(
      //     error.cause,
      //     id: 1,
      //   );
      // } catch (error) {
      //   print('error 3');
      //   print(error);
      //   sNotification.showError(
      //     intl.something_went_wrong,
      //     id: 1,
      //   );
      // }
    }
  }

  @observable
  bool showDetails = false;
  @action
  bool setShowDetails(bool value) => showDetails = value;

  @observable
  bool isFrozen = false;
  @action
  Future<void> setFrozen(bool value) async {
    if (value) {
      final context = getIt.get<AppRouter>().navigatorKey.currentContext;
      await sShowAlertPopup(
        context!,
        primaryText: intl.simple_card_froze_this_card,
        secondaryText: intl.simple_card_froze_description,
        primaryButtonName: intl.simple_card_froze_freeze,
        secondaryButtonName: intl.simple_card_froze_cancel,
        image: Image.asset(
          disclaimerAsset,
          width: 80,
          height: 80,
        ),
        onPrimaryButtonTap: () {
          frozenApprove(value);
          Navigator.pop(sRouter.navigatorKey.currentContext!);
        },
        onSecondaryButtonTap: () {
          Navigator.pop(sRouter.navigatorKey.currentContext!);
        },
      );
    } else {
      await frozenApprove(value);
    }
  }

  @action
  Future<void> frozenApprove(bool value) async {
    if (showDetails) {
      setShowDetails(false);
    }
    isFrozen = value;
    if (value) {
      sNotification.showError(
        intl.simple_card_froze_alert,
        id: 1,
        isError: false,
      );
    }
    try {
      final response = value
          ? await sNetwork.getWalletModule().postCardFreeze(cardId: cardFull?.cardId ?? '')
          : await sNetwork.getWalletModule().postCardUnfreeze(cardId: cardFull?.cardId ?? '');

      response.pick(
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );
    }
  }

  @observable
  SimpleCardSensitiveResponse? cardSensitiveData = SimpleCardSensitiveResponse(
    cardExpDate: '12/24',
    cardCvv: '234',
    cardHolderName: 'Test Test',
    cardNumber: '2444 4444 4444 4444',
  );

  @observable
  SimpleCardModel? card = SimpleCardModel(
    cardId: '',
    cardPan: '',
    cardExpDate: '',
    cardType: 'Virtual card',
    currency: 'EUR',
    nameOnCard: '',
    balance: Decimal.zero,
    status: AccountStatusCard.active,
  );

  @action
  void setCardInfo(SimpleCardModel? cardData) {
    card = cardData;
  }

  @observable
  CardDataModel? cardFull;

  @action
  void setCardFullInfo(CardDataModel? cardData) {
    cardFull = cardData;
  }

  @action
  Future<void> createCard(String pin) async {
    loader.startLoading();

    try {
      final response = await sNetwork.getWalletModule().postSimpleCardCreate(
        data: SimpleCardCreateRequest(
          requestId: DateTime.now().microsecondsSinceEpoch.toString(),
          pin: pin,
        ),
      );

      response.pick(
        onData: (data) async {
          setCardInfo(data.card);
          final context = getIt.get<AppRouter>().navigatorKey.currentContext;
          Navigator.pop(context!);
          await Navigator.push(
            context,
            PageRouteBuilder(
              opaque: false,
              barrierColor: Colors.white,
              pageBuilder: (BuildContext _, __, ___) {
                return const SetUpPasswordScreen();
              },
              transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                  ) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                final tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
            ),
          ).then((value) async {});
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            duration: 4,
            id: 1,
            needFeedback: true,
          );

          loader.finishLoading();
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      loader.finishLoading();
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      loader.finishLoading();
    }
  }

  @action
  Future<void> remindPin() async {
    try {
      final response =
        await sNetwork.getWalletModule()
            .postRemindPin(cardId: cardFull?.cardId ?? '');

      response.pick(
        onData: (SimpleCardRemindPinResponse value) {
          final context = getIt.get<AppRouter>().navigatorKey.currentContext;
          Navigator.pop(sRouter.navigatorKey.currentContext!);
          sShowAlertPopup(
            context!,
            primaryText: intl.simple_card_remind_title,
            secondaryText: '${intl.simple_card_remind_description} '
              '${value.phoneNumber != null
                ? '**${value.phoneNumber!.substring(value.phoneNumber!.length - 4)}'
                : ''}',
            primaryButtonName: intl.simple_card_remind_continue,
            secondaryButtonName: intl.simple_card_remind_cancel,
            image: Image.asset(
              mailAsset,
              width: 80,
              height: 80,
            ),
            onPrimaryButtonTap: () {
              Navigator.pop(sRouter.navigatorKey.currentContext!);
            },
            onSecondaryButtonTap: () {
              Navigator.pop(sRouter.navigatorKey.currentContext!);
            },
          );
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );
    }
  }

}
