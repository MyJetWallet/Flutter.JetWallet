import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/signal_r/models/client_detail_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

part 'payment_method_store.g.dart';

class PaymentMethodStore extends _PaymentMethodStoreBase with _$PaymentMethodStore {
  PaymentMethodStore() : super();

  static PaymentMethodStore of(BuildContext context) => Provider.of<PaymentMethodStore>(context, listen: false);
}

abstract class _PaymentMethodStoreBase with Store {
  @observable
  CurrencyModel? selectedAssset;

  @observable
  bool isHideCards = false;

  @computed
  List<CircleCard> get cards => sSignalRModules.cards.cardInfos;
  @computed
  List<SimpleBankingAccount> get accounts {
    final accounts = <SimpleBankingAccount>[];

    final simpleAccount = sSignalRModules.bankingProfileData?.simple?.account;

    if ((simpleAccount != null) && isSimpleAccountAvaible && simpleAccount.balance != Decimal.zero) {
      accounts.add(simpleAccount);
    }

    final bankingAccounts = sSignalRModules.bankingProfileData?.banking?.accounts
            ?.where((element) => ((element.balance ?? Decimal.zero) != Decimal.zero) && !(element.isHidden ?? false))
            .toList() ??
        <SimpleBankingAccount>[];

    if (isBankingAccountsAvaible) {
      accounts.addAll(bankingAccounts);
    }

    return accounts;
  }

  @computed
  bool get isCardsAvailable {
    if (isHideCards) {
      return false;
    }
    final isMethodAvaible =
        selectedAssset?.buyMethods.any((element) => element.id == PaymentMethodType.bankCard) ?? false;
    final isKycAllowed = getIt.get<KycService>().depositStatus == kycOperationStatus(KycStatus.allowed);
    final isNoBlocker =
        !sSignalRModules.clientDetail.clientBlockers.any((element) => element.blockingType == BlockingType.deposit);

    return (selectedAssset == null || (isMethodAvaible && isKycAllowed)) && isNoBlocker;
  }

  @computed
  bool get isSimpleAccountAvaible =>
      sSignalRModules.paymentProducts?.any((element) => element.id == AssetPaymentProductsEnum.simpleIbanAccount) ??
      false;

  @computed
  bool get isBankingAccountsAvaible {
    final isBankingIbanAccountAvaible =
        sSignalRModules.paymentProducts?.any((element) => element.id == AssetPaymentProductsEnum.bankingIbanAccount) ??
            false;

    final isMethodAvaible =
        selectedAssset?.buyMethods.any((element) => element.id == PaymentMethodType.ibanTransferUnlimint) ?? false;

    return isBankingIbanAccountAvaible && (selectedAssset == null || isMethodAvaible);
  }

  @action
  Future<void> init({
    CurrencyModel? asset,
    bool hideCards = false,
  }) async {
    isHideCards = hideCards;

    selectedAssset = asset;
  }
}

class PaymentMethodSearchModel {
  PaymentMethodSearchModel(this.type, this.name, this.method, this.card);

  int type = 0; // 0 - Card, 1 - AltMethod,
  String name = ''; // Sort by this parametr;
  BuyMethodDto? method;
  CircleCard? card;
}

bool isCardReachLimit(PaymentAsset asset) {
  int calcPercentage(Decimal first, Decimal second) {
    if (first == Decimal.zero) {
      return 0;
    }
    final doubleFirst = double.parse('$first');
    final doubleSecond = double.parse('$second');
    final doubleFinal = double.parse('${doubleFirst / doubleSecond}');

    return (doubleFinal * 100).round();
  }

  if (asset.limits != null) {
    var finalInterval = StateBarType.day1;
    var finalProgress = 0;
    var dayState = asset.limits!.dayValue == asset.limits!.dayLimit ? StateLimitType.block : StateLimitType.active;
    var weekState = asset.limits!.weekValue == asset.limits!.weekLimit ? StateLimitType.block : StateLimitType.active;
    var monthState =
        asset.limits!.monthValue == asset.limits!.monthLimit ? StateLimitType.block : StateLimitType.active;
    if (monthState == StateLimitType.block) {
      finalProgress = 100;
      finalInterval = StateBarType.day30;
      weekState = weekState == StateLimitType.block ? StateLimitType.block : StateLimitType.none;
      dayState = dayState == StateLimitType.block ? StateLimitType.block : StateLimitType.none;
    } else if (weekState == StateLimitType.block) {
      finalProgress = 100;
      finalInterval = StateBarType.day7;
      dayState = dayState == StateLimitType.block ? StateLimitType.block : StateLimitType.none;
      monthState = StateLimitType.none;
    } else if (dayState == StateLimitType.block) {
      finalProgress = 100;
      finalInterval = StateBarType.day1;
      weekState = StateLimitType.none;
      monthState = StateLimitType.none;
    } else {
      final dayLeft = asset.limits!.dayLimit - asset.limits!.dayValue;
      final weekLeft = asset.limits!.weekLimit - asset.limits!.weekValue;
      final monthLeft = asset.limits!.monthLimit - asset.limits!.monthValue;
      if (dayLeft <= weekLeft && dayLeft <= monthLeft) {
        finalInterval = StateBarType.day1;
        finalProgress = calcPercentage(
          asset.limits!.dayValue,
          asset.limits!.dayLimit,
        );
        dayState = StateLimitType.active;
        weekState = StateLimitType.none;
        monthState = StateLimitType.none;
      } else if (weekLeft <= monthLeft) {
        finalInterval = StateBarType.day7;
        finalProgress = calcPercentage(
          asset.limits!.weekValue,
          asset.limits!.weekLimit,
        );
        dayState = StateLimitType.none;
        weekState = StateLimitType.active;
        monthState = StateLimitType.none;
      } else {
        finalInterval = StateBarType.day30;
        finalProgress = calcPercentage(
          asset.limits!.monthValue,
          asset.limits!.monthLimit,
        );
        dayState = StateLimitType.none;
        weekState = StateLimitType.none;
        monthState = StateLimitType.active;
      }
    }

    final limitModel = CardLimitsModel(
      minAmount: asset.minAmount,
      maxAmount: asset.maxAmount,
      day1Amount: asset.limits!.dayValue,
      day1Limit: asset.limits!.dayLimit,
      day1State: dayState,
      day7Amount: asset.limits!.weekValue,
      day7Limit: asset.limits!.weekLimit,
      day7State: weekState,
      day30Amount: asset.limits!.monthValue,
      day30Limit: asset.limits!.monthLimit,
      day30State: monthState,
      barInterval: finalInterval,
      barProgress: finalProgress,
      leftHours: 0,
    );

    return limitModel.day1State == StateLimitType.block ||
        limitModel.day7State == StateLimitType.block ||
        limitModel.day30State == StateLimitType.block;
  } else {
    return false;
  }
}
