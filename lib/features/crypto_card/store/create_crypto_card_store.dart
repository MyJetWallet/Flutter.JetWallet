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
import 'package:jetwallet/features/crypto_card/utils/show_please_verify_account_popup.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/get_kuc_aid_plan.dart';
import 'package:jetwallet/features/kyc/kyc_verify_your_profile/utils/start_kyc_aid_flow.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
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
  StackLoaderStore loader = StackLoaderStore();

  @observable
  PriceCryptoCardResponseModel? price;

  @observable
  String? cardLable;

  @observable
  ObservableList<String> _avaibleAssetsSymbols = ObservableList.of([]);

  @computed
  ObservableList<CurrencyModel> get avaibleAssets {
    final result = ObservableList<CurrencyModel>.of([]);
    for (final symbol in _avaibleAssetsSymbols) {
      final asset = getIt<FormatService>().findCurrency(
        assetSymbol: symbol,
      );
      result.add(asset);
    }

    return result;
  }

  @observable
  CurrencyModel? selectedAsset;

  @computed
  CurrencyModel get priceAsset => getIt<FormatService>().findCurrency(
        assetSymbol: price?.assetSymbol ?? 'EUR',
      );

  @computed
  bool get isPayValid => selectedAsset != null && isEnoughBalanceToPay;

  @computed
  bool get isLableValid => cardLable?.isNotEmpty ?? false;

  @computed
  bool get isEnoughBalanceToPay {
    if (selectedAsset == null) return false;

    final userPrice = price?.userPrice ?? Decimal.zero;
    final needToPay = userPrice * Decimal.parse('1.05');

    final formatService = getIt.get<FormatService>();
    final avaibleBalance = formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: selectedAsset?.symbol ?? '',
      fromCurrencyAmmount: selectedAsset?.assetBalance ?? Decimal.zero,
      toCurrency: price?.assetSymbol ?? 'EUR',
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: true,
    );

    return needToPay < avaibleBalance;
  }

  @action
  Future<void> init() async {
    unawaited(_getPrice());
    unawaited(_getAssetsListCryptoCard());
  }

  @computed
  bool get showSearch => avaibleAssets.length > 7;

  @observable
  String searchValue = '';

  @computed
  ObservableList<CurrencyModel> get filterdAssets {
    final result = avaibleAssets.where((element) {
      return element.description.toLowerCase().contains(searchValue) ||
          element.symbol.toLowerCase().contains(searchValue);
    }).toList();

    result.sort((a, b) => b.baseBalance.compareTo(a.baseBalance));

    if (result.any((asset) => asset.symbol == 'USDT')) {
      final usdtAsset = result.firstWhere((asset) => asset.symbol == 'USDT');
      result.removeWhere((asset) => asset.symbol == 'USDT');
      result.insert(0, usdtAsset);
    }

    return ObservableList.of(result);
  }

  @action
  void onCahngeSearch(String value) {
    searchValue = value;
  }

  @action
  Future<void> onChooseAsset(CurrencyModel asset) async {
    selectedAsset = asset;
    if (!isEnoughBalanceToPay) {
      // TODO (Yaroslav): Replace the error when the design is ready
      sNotification.showError(
        'Not enough balance',
        id: 1,
        isError: false,
      );
    }
  }

  @action
  Future<void> startCreatingFlow() async {
    await _checkKycState(
      onKycAllowed: () async {
        await routCryptoCardPayAssetScreen();
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
  Future<void> _getPrice({bool showLoader = false}) async {
    try {
      if (showLoader) {
        loader.startLoadingImmediately();
      }

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
    } finally {
      if (showLoader) {
        loader.finishLoadingImmediately();
      }
    }
  }

  @action
  Future<void> _getAssetsListCryptoCard({bool showLoader = false}) async {
    try {
      if (showLoader) {
        loader.startLoadingImmediately();
      }
      final response = await sNetwork.getWalletModule().getAssetListCryptoCard();

      response.pick(
        onData: (data) {
          _avaibleAssetsSymbols = ObservableList.of(data.assets);
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
      );
    } finally {
      if (showLoader) {
        loader.finishLoadingImmediately();
      }
    }
  }

  @action
  Future<void> routCryptoCardPayAssetScreen() async {
    if (price == null) {
      unawaited(_getPrice(showLoader: true));
    }
    if (avaibleAssets.isEmpty) {
      unawaited(_getAssetsListCryptoCard(showLoader: true));
    }

    await sRouter.push(const CryptoCardPayAssetRoute());
  }

  @action
  void onContinueTap() {
    if (isPayValid) {
      sRouter.push(CryptoCardConfirmationRoute(fromAssetSymbol: selectedAsset?.symbol ?? ''));
    }
  }

  @action
  Future<void> routCryptoCardNameScreen() async {
    await sRouter.push(const CryptoCardNameRoute());
  }

  @action
  void skipCryptoCardNameSteep() {
    cardLable = null;
  }

  @action
  void setCryptoCardName(String name) {
    cardLable = name;
  }
}
