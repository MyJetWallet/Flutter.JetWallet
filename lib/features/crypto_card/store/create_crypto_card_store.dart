import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/sumsub_service/sumsub_service.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/features/crypto_card/utils/show_crypto_card_acknowledgment_bottom_sheet.dart';
import 'package:jetwallet/features/crypto_card/utils/show_insufficient_balance_account_popup.dart';
import 'package:jetwallet/features/crypto_card/utils/show_please_verify_account_popup.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/get_kuc_aid_plan.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/start_kyc_aid_flow.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/crypto_card_message_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/create_crypto_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/price_crypto_card_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/kyc_plan_responce_model.dart';

part 'create_crypto_card_store.g.dart';

@lazySingleton
class CreateCryptoCardStore extends _CreateCryptoCardStoreBase with _$CreateCryptoCardStore {
  CreateCryptoCardStore() : super();

  _CreateCryptoCardStoreBase of(BuildContext context) => Provider.of<CreateCryptoCardStore>(context);
}

abstract class _CreateCryptoCardStoreBase with Store {
  @observable
  bool cardIsCreating = false;

  @observable
  PriceCryptoCardResponseModel? price;

  @observable
  String? cardLable;

  @computed
  CurrencyModel get defaultAsset => getIt<FormatService>().findCurrency(
        assetSymbol: 'USDT',
      );

  @computed
  bool get isLableValid => cardLable?.isNotEmpty ?? false;

  @computed
  bool get isIsEnoughBalanceToPay {
    final needToPay = price?.userPrice ?? Decimal.zero;

    final formatService = getIt.get<FormatService>();
    final avaibleBalance = formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: defaultAsset.symbol,
      fromCurrencyAmmount: defaultAsset.assetBalance,
      toCurrency: price?.assetSymbol ?? 'EUR',
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: true,
    );

    return needToPay < avaibleBalance;
  }

  @action
  Future<void> startCreatingFlow() async {
    unawaited(_getPrice());

    await _checkKycState(
      onKycAllowed: () async {
        await _showAcknowledgmentBottomSheet();
      },
    );
  }

  @action
  Future<void> _checkKycState({required Future<void> Function() onKycAllowed}) async {
    final kycState = getIt.get<KycService>();
    final kycAlertHandler = getIt.get<KycAlertHandler>();

    if (kycState.verificationRequired) {
      final context = sRouter.navigatorKey.currentContext;
      if (context == null) return;
      final result = await showPleaseVerifyAccountPopUp(context: context);
      if (result == true) {
        await _startKycVereficationFlow();
      }
    } else {
      kycAlertHandler.handle(
        status: kycState.depositStatus,
        isProgress: kycState.verificationInProgress,
        currentNavigate: () async {
          await onKycAllowed();
        },
        requiredDocuments: kycState.requiredDocuments,
        requiredVerifications: kycState.requiredVerifications,
        customBlockerText: intl.profile_kyc_bloked_alert,
      );
    }
  }

  @action
  Future<void> _startKycVereficationFlow() async {
    final kycPlan = await getKYCAidPlan();
    if (kycPlan == null) return;

    if (kycPlan.provider == KycProvider.sumsub) {
      await getIt<SumsubService>().launch(
        isBanking: false,
      );
    } else if (kycPlan.provider == KycProvider.kycAid) {
      await startKycAidFlow(kycPlan);
    }
  }

  @action
  Future<void> _getPrice() async {
    try {
      final response = await sNetwork.getWalletModule().getPriceCryptoCard();
      response.pick(
        onData: (data) {
          price = data;
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );
    }
  }

  Future<void> _showAcknowledgmentBottomSheet() async {
    final context = sRouter.navigatorKey.currentContext;
    if (context == null) return;
    final acknowledgmentResult = await showCryptoCardAcknowledgmentBottomSheet(context);
    if (acknowledgmentResult == true) {
      await routCryptoCardDefaultAsseScreen();
    }
  }

  @action
  Future<void> routCryptoCardDefaultAsseScreen() async {
    await sRouter.push(const CryptoCardDefaultAssetRoute());
  }

  @action
  Future<void> routCardIssueCostSheetScreen() async {
    if (price == null) {
      await _getPrice();
    }
    if (isIsEnoughBalanceToPay) {
      await sRouter.push(const CryptoCardIssueCostRoute());
    } else {
      final context = sRouter.navigatorKey.currentContext;
      if (context == null) return;
      await showInsufficientBalanceAccountPopup(context: context);
    }
  }

  Future<void> routCryptoCardNameScreen() async {
    await sRouter.push(const CryptoCardNameRoute());
  }

  @action
  void skipCryptoCardNameSteep() {
    cardLable = null;
    createCryptoCard();
  }

  @action
  void setCryptoCardName(String name) {
    cardLable = name;
  }

  @action
  Future<void> createCryptoCard() async {
    try {
      getIt.get<GlobalLoader>().setLoading(true);
      final model = CreateCryptoCardRequestModel(
        label: cardLable,
      );

      final response = await sNetwork.getWalletModule().createCryptoCard(model);

      response.pick(
        onNoError: (data) async {
          // TODO (Yaroslav): remove this code
          sSignalRModules.cryptoCardProfile = CryptoCardProfile(
            associateAssetList: ['USDT'],
            cards: [
              CryptoCardModel(
                cardId: 'mock',
                label: cardLable ?? '',
                last4: '5555',
                status: CryptoCardStatus.inCreation,
              ),
            ],
          );
          unawaited(
            Future.delayed(
              const Duration(seconds: 3),
              () {
                sSignalRModules.cryptoCardProfile = CryptoCardProfile(
                  associateAssetList: ['USDT'],
                  cards: [
                    CryptoCardModel(
                      cardId: 'mock',
                      label: cardLable ?? '',
                      last4: '5555',
                      status: CryptoCardStatus.active,
                    ),
                  ],
                );
              },
            ),
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
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    } finally {
      getIt.get<GlobalLoader>().setLoading(false);
      sRouter.popUntilRoot();
    }
  }
}