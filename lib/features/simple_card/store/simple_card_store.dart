import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/features/pin_screen/ui/pin_screen.dart';
import 'package:mobx/mobx.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_create_response.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_remind_pin_response.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_sensitive_request.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_sevsitive_response.dart';
import 'package:simple_networking/modules/wallet_api/models/simple_card/simple_card_terminate_request_model.dart';

import '../../../core/di/di.dart';
import '../../../core/l10n/i10n.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/key_value_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../utils/constants.dart';
import '../../app/store/global_loader.dart';
import '../../my_wallets/helper/show_wallet_verify_account.dart';
import '../ui/set_up_password_screen.dart';
import '../ui/widgets/show_complete_verification_account.dart';

part 'simple_card_store.g.dart';

@lazySingleton
class SimpleCardStore = _SimpleCardStoreBase with _$SimpleCardStore;

abstract class _SimpleCardStoreBase with Store {
  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool canTap = true;

  @action
  void setCanTap(bool newValue) {
    canTap = newValue;
  }

  @computed
  ObservableList<String> get cardsWasShowed => ObservableList.of(
        sSignalRModules.keyValue.cardsSimple?.value ?? [],
      );

  final storageService = getIt.get<LocalStorageService>();

  @observable
  bool wasCardBannerClosed = true;

  @action
  Future<void> initStore() async {
    allCards = sSignalRModules.bankingProfileData?.banking?.cards
        ?.where((element) => element.status != AccountStatusCard.inactive)
        .toList();
    final cards = sSignalRModules.bankingProfileData?.banking?.cards;
    if (cards != null && cards.isNotEmpty) {
      final activeCard = cards.where((element) => element.status != AccountStatusCard.inactive).toList();
      if (activeCard.isNotEmpty) {
        setCardFullInfo(activeCard[activeCard.length - 1]);
      }
    }
  }

  @action
  Future<void> closeBanner() async {
    wasCardBannerClosed = true;
    await sLocalStorageService.setString(isCardBannerClosed, 'true');
  }

  @action
  Future<void> checkCardBanner() async {
    final checkClosedBanner = await sLocalStorageService.getValue(isCardBannerClosed);
    wasCardBannerClosed = checkClosedBanner == 'true';

    final cards = sSignalRModules.bankingProfileData?.banking?.cards;
    if (cards != null && cards.isNotEmpty) {
      var needNotification = false;
      var cardsShown = cardsWasShowed.toList();
      for (final cardEl in cards) {
        if (!cardsWasShowed.contains(cardEl.cardId) && cardEl.status == AccountStatusCard.active) {
          needNotification = true;
          cardsShown = [
            ...cardsShown,
            cardEl.cardId ?? '',
          ];
        }
      }
      if (needNotification) {
        sAnalytics.viewCardIsReady();
        sNotification.showError(
          intl.simple_card_is_ready,
          id: 1,
          isError: false,
        );
        await saveReceivedCards(cardsShown);
      }
    }
  }

  @action
  Future<void> initFullCardIn(String cardId) async {
    cardSensitiveData = SimpleCardSensitiveResponse(
      cardNumber: '',
      cardHolderName: '',
      cardCvv: '',
      cardExpDate: '',
    );
    showDetails = false;
    final cards = allCards;
    if (cards != null && cards.isNotEmpty) {
      final activeCard = cards.where((element) => element.cardId == cardId).toList();
      if (activeCard.isNotEmpty) {
        setCardFullInfo(activeCard[activeCard.length - 1]);
        isFrozen = activeCard[activeCard.length - 1].status == AccountStatusCard.frozen;
        if (activeCard[activeCard.length - 1].status == AccountStatusCard.frozen) {
          sAnalytics.viewFrozenCard(cardID: cardId);
        }

        if (allSensitive.where((element) => element.cardId == cardId).toList().isEmpty) {
          try {
            final rsa = RsaKeyHelper();
            final keyPair = getRsaKeyPair(rsa.getSecureRandom());

            final rsaPublicKey = keyPair.publicKey as RSAPublicKey;
            final rsaPrivateKey = keyPair.privateKey as RSAPrivateKey;
            final publicKey = rsa.encodePublicKeyToPemPKCS1(rsaPublicKey);
            final storageService = getIt.get<LocalStorageService>();

            final pin = await storageService.getValue(pinStatusKey);
            final serverTimeResponse =
                await getIt.get<SNetwork>().simpleNetworkingUnathorized.getAuthModule().getServerTime();
            final model = SimpleCardSensitiveRequest(
              cardId: activeCard[activeCard.length - 1].cardId ?? '',
              publicKey: publicKey
                  .replaceAll('\r\n', '')
                  .replaceAll('-----BEGIN RSA PUBLIC KEY-----', '')
                  .replaceAll('-----END RSA PUBLIC KEY-----', ''),
              pin: pin ?? '',
              timeStamp: serverTimeResponse.data!.time,
            );

            final response = await sNetwork.getWalletModule().postSensitiveData(data: model);

            response.pick(
              onData: (data) async {
                final encrypter = Encrypter(
                  RSA(publicKey: rsaPublicKey, privateKey: rsaPrivateKey),
                );
                final cardNumber = encrypter.decrypt(Encrypted.fromBase64(data.cardNumber!));
                final cardHolder = encrypter.decrypt(Encrypted.fromBase64(data.cardHolderName!));
                final cardDate = encrypter.decrypt(Encrypted.fromBase64(data.cardExpDate!));
                final cardCVV = encrypter.decrypt(Encrypted.fromBase64(data.cardCvv!));
                final text = cardNumber;

                final buffer = StringBuffer();
                for (var i = 0; i < text.length; i++) {
                  buffer.write(text[i]);
                  final nonZeroIndex = i + 1;
                  if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
                    buffer.write(' ');
                  }
                }

                final finalCardNumber = buffer.toString();

                cardSensitiveData = SimpleCardSensitiveResponse(
                  cardExpDate: cardDate,
                  cardCvv: cardCVV,
                  cardHolderName: cardHolder,
                  cardNumber: finalCardNumber,
                );

                allSensitive.add(
                  SimpleCardSensitiveWithId(
                    cardExpDate: cardDate,
                    cardCvv: cardCVV,
                    cardHolderName: cardHolder,
                    cardNumber: finalCardNumber,
                    cardId: cardId,
                  ),
                );
              },
              onError: (error) {},
            );
          } catch (error) {
            log(error.toString(), error: error);
          }
        } else {
          final cardSens = allSensitive.where((element) => element.cardId == cardId).toList()[0];
          cardSensitiveData = SimpleCardSensitiveResponse(
            cardNumber: cardSens.cardNumber,
            cardHolderName: cardSens.cardHolderName,
            cardCvv: cardSens.cardCvv,
            cardExpDate: cardSens.cardExpDate,
          );
        }
      }
    }
  }

  @observable
  List<CardDataModel>? allCards = sSignalRModules.bankingProfileData?.banking?.cards
      ?.where(
        (element) => element.status != AccountStatusCard.inactive && element.status != AccountStatusCard.unsupported,
      )
      .toList();

  @observable
  bool showDetails = false;
  @action
  bool setShowDetails(bool value) => showDetails = value;

  @observable
  List<SimpleCardSensitiveWithId> allSensitive = [];

  @observable
  bool isFrozen = false;
  @action
  Future<void> setFrozen(bool value) async {
    if (value) {
      final context = getIt.get<AppRouter>().navigatorKey.currentContext;
      Navigator.pop(sRouter.navigatorKey.currentContext!);
      sAnalytics.viewFreezeCardPopup(cardID: cardFull?.cardId ?? '');
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
          sAnalytics.tapConfirmFreezeCard(cardID: cardFull?.cardId ?? '');
          frozenApprove(value);
          Navigator.pop(sRouter.navigatorKey.currentContext!);
        },
        onSecondaryButtonTap: () {
          sAnalytics.tapCancelFreeze(cardID: cardFull?.cardId ?? '');
          Navigator.pop(sRouter.navigatorKey.currentContext!);
        },
      );
    } else {
      await frozenApprove(value);
    }
  }

  @action
  Future<void> frozenApprove(bool value) async {
    loader.startLoadingImmediately();
    try {
      final response = value
          ? await sNetwork.getWalletModule().postCardFreeze(cardId: cardFull?.cardId ?? '')
          : await sNetwork.getWalletModule().postCardUnfreeze(cardId: cardFull?.cardId ?? '');
      response.pick(
        onNoError: (data) {
          if (showDetails) {
            setShowDetails(false);
          }
          if (value) {
            sAnalytics.viewFrozenCard(cardID: cardFull?.cardId ?? '');
          }
          isFrozen = value;
          setCardFullInfo(
            cardFull!.copyWith(
              status: value ? AccountStatusCard.frozen : AccountStatusCard.active,
            ),
          );
          final newCards = allCards?.map((e) {
            return e.cardId == cardFull?.cardId
                ? e.copyWith(
                    status: value ? AccountStatusCard.frozen : AccountStatusCard.active,
                  )
                : e;
          }).toList();
          allCards = newCards;
          sSignalRModules.setBankingProfileData(
            sSignalRModules.bankingProfileData!.copyWith(
              banking: sSignalRModules.bankingProfileData!.banking!.copyWith(
                cards: newCards,
              ),
            ),
          );
          Timer(
            const Duration(seconds: 1),
            () {
              loader.finishLoadingImmediately();
            },
          );
          if (value) {
            sNotification.showError(
              intl.simple_card_froze_alert,
              id: 1,
              isError: false,
            );
          }
        },
        onError: (error) {
          loader.finishLoadingImmediately();
          sAnalytics.viewErrorOnCardScreen(
            cardID: cardFull?.cardId ?? '',
            reason: error.cause,
          );
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } on ServerRejectException catch (error) {
      loader.finishLoadingImmediately();
      sAnalytics.viewErrorOnCardScreen(
        cardID: cardFull?.cardId ?? '',
        reason: error.cause,
      );
      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      loader.finishLoadingImmediately();
      sAnalytics.viewErrorOnCardScreen(
        cardID: cardFull?.cardId ?? '',
        reason: intl.something_went_wrong,
      );
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );
    }
  }

  @observable
  SimpleCardSensitiveResponse? cardSensitiveData = SimpleCardSensitiveResponse(
    cardExpDate: '',
    cardCvv: '',
    cardHolderName: '',
    cardNumber: '',
  );

  @observable
  CardDataModel? cardFull;

  @action
  void setCardFullInfo(CardDataModel? cardData) {
    cardFull = cardData;
  }

  @action
  Future<void> createCard(String pin, String password) async {
    loader.startLoading();

    try {
      final response = await sNetwork.getWalletModule().postSimpleCardCreate(
            data: SimpleCardCreateRequest(
              requestId: DateTime.now().microsecondsSinceEpoch.toString(),
              pin: pin,
              password: password,
            ),
          );
      final context = getIt.get<AppRouter>().navigatorKey.currentContext;

      if (response.hasError) {
        sNotification.showError(
          response.error?.cause ?? intl.something_went_wrong_try_again,
          id: 1,
          needFeedback: true,
        );

        Navigator.pop(context!);

        loader.finishLoading();
      } else {
        if (response.data!.simpleKycRequired != null && response.data!.simpleKycRequired!) {
          loader.finishLoading();
          Navigator.pop(context!);
          showWalletVerifyAccount(
            context,
            after: _afterVerification,
            isBanking: false,
          );
        } else if (response.data!.bankingKycRequired != null && response.data!.bankingKycRequired!) {
          sAnalytics.viewCompleteKYCForCard();
          loader.finishLoading();
          Navigator.pop(context!);
          showCompleteVerificationAccount(
            context,
            _afterVerification,
            loader,
          );
        } else {
          loader.finishLoading();
          Navigator.pop(context!);
          sNotification.showError(
            intl.simple_card_password_working,
            isError: false,
          );
        }
      }
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
        needFeedback: true,
      );

      loader.finishLoading();
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );

      loader.finishLoading();
    }
  }

  void _afterVerification() {
    getIt.get<GlobalLoader>().setLoading(false);

    sNotification.showError(intl.simple_card_password_working, isError: false);
    sAnalytics.viewWorkingOnYourCard();
  }

  @action
  Future<void> gotToSetup() async {
    final context = getIt.get<AppRouter>().navigatorKey.currentContext;
    Navigator.pop(context!);
    sAnalytics.viewSetupPassword(
      cardID: cardFull?.cardId ?? '',
    );
    await Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.white,
        pageBuilder: (BuildContext _, __, ___) {
          return const SetUpPasswordScreen(
            isCreatePassword: true,
          );
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

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    ).then((value) async {});
  }

  @action
  Future<void> remindPinPhone() async {
    Navigator.pop(sRouter.navigatorKey.currentContext!);
    sAnalytics.tapOnRemindPin(cardID: cardFull?.cardId ?? '');
    loader.startLoadingImmediately();
    try {
      final response = await sNetwork.getWalletModule().postRemindPinPhone(cardId: cardFull?.cardId ?? '');

      response.pick(
        onData: (SimpleCardRemindPinResponse value) {
          loader.finishLoadingImmediately();
          final context = getIt.get<AppRouter>().navigatorKey.currentContext;
          sAnalytics.viewRemindPinSheet(cardID: cardFull?.cardId ?? '');
          sShowAlertPopup(
            context!,
            primaryText: intl.simple_card_remind_title,
            secondaryText: '${intl.simple_card_remind_description} '
                '${value.phoneNumber != null ? '**${value.phoneNumber!.substring(value.phoneNumber!.length - 4)}' : ''}',
            primaryButtonName: intl.simple_card_remind_continue,
            secondaryButtonName: intl.simple_card_remind_cancel,
            image: Image.asset(
              mailAsset,
              width: 80,
              height: 80,
            ),
            onPrimaryButtonTap: () {
              sAnalytics.tapInContinueRemindPin(cardID: cardFull?.cardId ?? '');
              remindPin();
            },
            onSecondaryButtonTap: () {
              sAnalytics.tapOnCancelRemindPin(cardID: cardFull?.cardId ?? '');
              Navigator.pop(sRouter.navigatorKey.currentContext!);
            },
          );
        },
        onError: (error) {
          loader.finishLoadingImmediately();
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } on ServerRejectException catch (error) {
      loader.finishLoadingImmediately();
      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      loader.finishLoadingImmediately();
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );
    }
  }

  @action
  Future<void> remindPin() async {
    Navigator.pop(sRouter.navigatorKey.currentContext!);
    loader.startLoadingImmediately();
    try {
      final response = await sNetwork.getWalletModule().postRemindPin(cardId: cardFull?.cardId ?? '');

      response.pick(
        onNoError: (value) {
          loader.finishLoadingImmediately();
          sNotification.showError(
            intl.simple_card_pin_was_send,
            id: 1,
            isError: false,
          );
        },
        onError: (error) {
          loader.finishLoadingImmediately();
          sAnalytics.viewErrorOnCardScreen(
            cardID: cardFull?.cardId ?? '',
            reason: error.cause,
          );
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } on ServerRejectException catch (error) {
      loader.finishLoadingImmediately();
      sAnalytics.viewErrorOnCardScreen(
        cardID: cardFull?.cardId ?? '',
        reason: error.cause,
      );
      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      loader.finishLoadingImmediately();
      sAnalytics.viewErrorOnCardScreen(
        cardID: cardFull?.cardId ?? '',
        reason: intl.something_went_wrong,
      );
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );
    }
  }

  @action
  Future<void> terminateCard() async {
    sAnalytics.tapOnTheTerminateButton(cardID: cardFull?.cardId ?? '');
    try {
      final context = sRouter.navigatorKey.currentContext!;

      if ((cardFull?.balance ?? Decimal.zero) != Decimal.zero) {
        sAnalytics.terminateWithBalancePopupScreenView(
          cardID: cardFull?.cardId ?? '',
        );

        await sShowAlertPopup(
          context,
          primaryText: intl.simple_card_terminate_card,
          secondaryText: intl.simple_card_terminate_only_available_alert,
          primaryButtonName: intl.simple_card_terminate_got_it,
          onPrimaryButtonTap: () {
            sRouter.maybePop();
          },
        );

        return;
      }

      var continueTrminate = false;

      sAnalytics.approveTerminatePopupScreenView(
        cardID: cardFull?.cardId ?? '',
      );

      await sShowAlertPopup(
        context,
        primaryText: intl.simple_card_terminate_terminate_card_question,
        secondaryText:
            '${intl.simple_card_terminate_terminate_warning_1} ** ${cardFull?.last4NumberCharacters} ${intl.simple_card_terminate_terminate_warning_2}',
        primaryButtonName: intl.simple_card_terminate_confirm,
        onPrimaryButtonTap: () {
          sAnalytics.tapOnTheConfirmTerminateButton(
            cardID: cardFull?.cardId ?? '',
          );
          continueTrminate = true;
          sRouter.maybePop();
        },
        primaryButtonType: SButtonType.primary3,
        secondaryButtonName: intl.simple_card_terminate_cancel,
        onSecondaryButtonTap: () {
          sAnalytics.tapOnTheCancelTerminateButton(
            cardID: cardFull?.cardId ?? '',
          );
          continueTrminate = false;
          sRouter.maybePop();
        },
      );

      if (!continueTrminate) return;

      var isVerifaierd = false;

      sAnalytics.confirmTerminateWithPinScreenView(
        cardID: cardFull?.cardId ?? '',
      );

      await showPinScreen(
        context: context,
        onCompled: () {
          isVerifaierd = true;
          sRouter.maybePop();
        },
      );

      if (!isVerifaierd) return;

      loader.startLoadingImmediately();

      sAnalytics.pleaseWaitLoaderOnCardTerminateLoadingView(
        cardID: cardFull?.cardId ?? '',
      );

      final response = await sNetwork.getWalletModule().postCardTerminate(
            model: SimpleCardTerminateRequestModel(cardId: cardFull?.cardId ?? ''),
          );

      loader.finishLoadingImmediately();

      response.pick(
        onNoError: (data) async {
          allCards?.removeWhere((element) => element.cardId == cardFull?.cardId);

          await sRouter.maybePop();
          await sRouter.maybePop();

          sAnalytics.theCardHasBeenTerminateToastView(
            cardID: cardFull?.cardId ?? '',
          );

          sNotification.showError(
            '${intl.simple_card_terminate_success_1} •• ${cardFull?.last4NumberCharacters} ${intl.simple_card_terminate_success_2}',
            id: 1,
            isError: false,
          );
        },
        onError: (error) {
          sAnalytics.viewErrorOnCardScreen(
            cardID: cardFull?.cardId ?? '',
            reason: error.cause,
          );
          sNotification.showError(
            error.cause,
            id: 3,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sAnalytics.viewErrorOnCardScreen(
        cardID: cardFull?.cardId ?? '',
        reason: error.cause,
      );
      sNotification.showError(
        error.cause,
        id: 4,
        needFeedback: true,
      );

      loader.finishLoading();
    } catch (error) {
      sAnalytics.viewErrorOnCardScreen(
        cardID: cardFull?.cardId ?? '',
        reason: intl.something_went_wrong_try_again2,
      );
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 5,
        needFeedback: true,
      );

      loader.finishLoading();
    }
  }

  Future<void> showPinScreen({
    required void Function() onCompled,
    required BuildContext context,
  }) async {
    await Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.white,
        pageBuilder: (BuildContext context, _, __) {
          return PinScreen(
            union: const Change(),
            isConfirmCard: true,
            isChangePhone: true,
            alwaysShowForgotPassword: true,
            onChangePhone: (String newPin) {
              onCompled();
            },
            onBackPressed: () {
              Navigator.pop(context);
            },
            onWrongPin: (String error) {},
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  void localUpdateCardLable(String newLabel) {
    cardFull = cardFull?.copyWith(
      label: newLabel,
    );

    final newCards = allCards?.map((e) {
      return e.cardId == cardFull?.cardId
          ? e.copyWith(
              label: newLabel,
            )
          : e;
    }).toList();
    allCards = newCards;
  }

  @action
  Future<void> saveReceivedCards(List<String> newList) async {
    await getIt.get<KeyValuesService>().addToKeyValue(
          KeyValueRequestModel(
            keys: [
              KeyValueResponseModel(
                key: cardsSimpleKey,
                value: jsonEncode(newList),
              ),
            ],
          ),
        );
  }
}
