import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
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
import '../../../utils/constants.dart';
import '../../my_wallets/helper/show_wallet_verify_account.dart';
import '../ui/set_up_password_screen.dart';
import '../ui/widgets/show_complete_verification_account.dart';

part 'simple_card_store.g.dart';

@lazySingleton
class SimpleCardStore = _SimpleCardStoreBase with _$SimpleCardStore;


abstract class _SimpleCardStoreBase with Store {

  @observable
  StackLoaderStore loader = StackLoaderStore();

  final storageService = getIt.get<LocalStorageService>();

  @action
  Future<void> initStore() async {
    allCards = sSignalRModules.bankingProfileData
        ?.banking?.cards
        ?.where((element) => element.status != AccountStatusCard.inactive).toList();
    final cards = sSignalRModules.bankingProfileData?.banking?.cards;
    if (cards != null && cards.isNotEmpty) {
      final activeCard = cards
          .where((element) => element.status != AccountStatusCard.inactive)
          .toList();
      if (activeCard.isNotEmpty) {
        setCardFullInfo(activeCard[activeCard.length - 1]);
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
    final cards = sSignalRModules.bankingProfileData?.banking?.cards;
    if (cards != null && cards.isNotEmpty) {
      final activeCard = cards
          .where((element) => element.cardId == cardId)
          .toList();
      if (activeCard.isNotEmpty) {
        setCardFullInfo(activeCard[activeCard.length - 1]);
        isFrozen = activeCard[activeCard.length - 1].status == AccountStatusCard.frozen;

        if (allSensitive.where((element) => element.cardId == cardId).toList().isEmpty) {
          try {

            final rsa = RsaKeyHelper();
            final keyPair = getRsaKeyPair(rsa.getSecureRandom());

            final rsaPublicKey = keyPair.publicKey as RSAPublicKey;
            final rsaPrivateKey = keyPair.privateKey as RSAPrivateKey;
            final publicKey = rsa.encodePublicKeyToPemPKCS1(rsaPublicKey);
            final privateKey = rsa.encodePrivateKeyToPemPKCS1(rsaPrivateKey);
            final storageService = getIt.get<LocalStorageService>();

            final pin = await storageService.getValue(pinStatusKey);
            final serverTimeResponse = await getIt
                .get<SNetwork>()
                .simpleNetworkingUnathorized
                .getAuthModule()
                .getServerTime();
            final model = SimpleCardSensitiveRequest(
              cardId: activeCard[activeCard.length - 1].cardId ?? '',
              publicKey: publicKey
                  .replaceAll('\r\n', '')
                  .replaceAll('-----BEGIN RSA PUBLIC KEY-----', '')
                  .replaceAll('-----END RSA PUBLIC KEY-----', ''),
              pin: pin ?? '',
              timeStamp: serverTimeResponse.data!.time,
            );

            final response =
            await sNetwork.getWalletModule().postSensitiveData(data: model);

            response.pick(
              onData: (data) async {
                final encrypter = Encrypter(RSA(publicKey: rsaPublicKey, privateKey: rsaPrivateKey));
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

                allSensitive.add(SimpleCardSensitiveWithId(
                  cardExpDate: cardDate,
                  cardCvv: cardCVV,
                  cardHolderName: cardHolder,
                  cardNumber: finalCardNumber,
                  cardId: cardId,
                ),);

              },
              onError: (error) {},
            );
          } catch (error) { }
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
  List<CardDataModel>? allCards = sSignalRModules.bankingProfileData
      ?.banking?.cards
      ?.where((element) => element.status != AccountStatusCard.inactive).toList();

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
    setCardFullInfo(cardFull!.copyWith(
      status: value ? AccountStatusCard.frozen : AccountStatusCard.active,
    ),);
    final newCards = allCards?.map((e) {
      return e.cardId == cardFull?.cardId
          ? e.copyWith(
            status: value
              ? AccountStatusCard.frozen
              : AccountStatusCard.active,
      ) : e;
    }).toList();
    allCards = newCards;
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
    cardExpDate: '',
    cardCvv: '',
    cardHolderName: '',
    cardNumber: '',
  );

  @observable
  SimpleCardModel? card;

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
          intl.something_went_wrong_try_again,
          duration: 4,
          id: 1,
          needFeedback: true,
        );

        Navigator.pop(context!);
      } else {


        void _afterVerification() {
          Navigator.pop(context!);

          sNotification.showError(intl.simple_card_password_working, isError: false);
        }

        if (response.data!.simpleKycRequired != null && response.data!.simpleKycRequired!) {
          Navigator.pop(context!);
          showWalletVerifyAccount(
            context,
            after: _afterVerification,
            isBanking: false,
          );
        } else if (response.data!.bankingKycRequired != null && response.data!.bankingKycRequired!) {
          Navigator.pop(context!);
          showCompleteVerificationAccount(
            context,
            loader,
            _afterVerification,
          );
        } else {
          Navigator.pop(context!);
          sNotification.showError(intl.simple_card_password_working, isError: false);
        }
      }

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
  Future<void> gotToSetup() async {
    final context = getIt.get<AppRouter>().navigatorKey.currentContext;
    Navigator.pop(context!);
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

          final tween = Tween(begin: begin, end: end)
              .chain(CurveTween(curve: curve));

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
    try {
      final response =
        await sNetwork.getWalletModule()
            .postRemindPinPhone(cardId: cardFull?.cardId ?? '');

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
              remindPin();
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

  @action
  Future<void> remindPin() async {
    try {
      final response =
        await sNetwork.getWalletModule()
            .postRemindPin(cardId: cardFull?.cardId ?? '');

      response.pick(
        onNoError: (value) {
          Navigator.pop(sRouter.navigatorKey.currentContext!);
          sNotification.showError(
            intl.simple_card_pin_was_send,
            id: 1,
            isError: false,
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