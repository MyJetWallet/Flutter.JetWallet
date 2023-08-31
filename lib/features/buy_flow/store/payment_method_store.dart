
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

part 'payment_method_store.g.dart';

class PaymentMethodStore extends _PaymentMethodStoreBase
    with _$PaymentMethodStore {
  PaymentMethodStore() : super();

  static PaymentMethodStore of(BuildContext context) =>
      Provider.of<PaymentMethodStore>(context, listen: false);
}

abstract class _PaymentMethodStoreBase with Store {
  TextEditingController searchController = TextEditingController();

  @observable
  CurrencyModel? selectedAssset;
  @observable
  PaymentAsset? selectedCurrency;

  @observable
  bool cardSupportForThisAsset = false;
  @observable
  bool isCardReachLimits = false;

  @computed
  CurrencyModel get buyCurrency => getIt.get<FormatService>().findCurrency(
        findInHideTerminalList: true,
        assetSymbol: selectedCurrency?.asset ?? 'BTC',
      );

  @computed
  List<CircleCard> get unlimintAltCards => sSignalRModules.cards.cardInfos
      .where(
        (element) =>
            element.integration == IntegrationType.unlimintAlt &&
            element.cardAssetSymbol == selectedCurrency!.asset,
      )
      .toList();

  @observable
  ObservableList<BuyMethodDto> cardsMethods = ObservableList.of([]);
  @observable
  ObservableList<CircleCard> cardsMethodsFiltred = ObservableList.of([]);

  @observable
  ObservableList<BuyMethodDto> localMethods = ObservableList.of([]);
  @observable
  ObservableList<BuyMethodDto> localMethodsFilted = ObservableList.of([]);

  @observable
  ObservableList<BuyMethodDto> p2pMethods = ObservableList.of([]);
  @observable
  ObservableList<BuyMethodDto> p2pMethodsFiltred = ObservableList.of([]);

  @observable
  ObservableList<PaymentMethodSearchModel> searchList = ObservableList.of([]);

  @action
  Future<void> init(CurrencyModel asset, PaymentAsset currency) async {
    sAnalytics.paymentMethodScreenView();

    selectedAssset = asset;
    selectedCurrency = currency;

    isCardReachLimits = isCardReachLimit(currency);

    if (asset.buyMethods.isNotEmpty) {
      for (final element in asset.buyMethods) {
        final isCurrExist = element.paymentAssets!.indexWhere(
          (element) => element.asset == buyCurrency.symbol,
        );

        if (element.category == PaymentMethodCategory.cards) {
          if (isCurrExist != -1) {
            if (element.paymentAssets![isCurrExist].maxAmount != Decimal.zero) {
              cardsMethods.add(element);
            }
          }
        } else if (element.category == PaymentMethodCategory.local) {
          if (isCurrExist != -1) {
            if (element.paymentAssets![isCurrExist].maxAmount != Decimal.zero) {
              localMethods.add(element);
            }
          }
        } else if (element.category == PaymentMethodCategory.p2p) {
          if (isCurrExist != -1) {
            if (element.paymentAssets![isCurrExist].maxAmount != Decimal.zero) {
              p2pMethods.add(element);
            }
          }
        }
      }

      final storage = sLocalStorageService;

      final cardM = await storage.getValue(bankLastMethodId);
      if (cardM != null) {
        sSignalRModules.cards.cardInfos.sort((a, b) => a.id == cardM ? 0 : 1);
      }

      final localLM = await storage.getValue(localLastMethodId);
      if (localLM != null) {
        final localIndex = localMethods.indexWhere(
          (element) => element.id.toString() == (localLM ?? ''),
        );

        if (localIndex != -1) {
          final localObject = localMethods[localIndex];

          localMethods.removeAt(localIndex);
          localMethods.insert(0, localObject);
        }
      }

      final p2pLM = await storage.getValue(p2pLastMethodId);
      if (p2pLM != null) {
        final localIndex = p2pMethods.indexWhere(
          (element) => element.id.toString() == (p2pLM ?? ''),
        );

        if (localIndex != -1) {
          final localObject = p2pMethods[localIndex];

          p2pMethods.removeAt(localIndex);
          p2pMethods.insert(0, localObject);
        }
      }

      cardsMethodsFiltred = ObservableList.of(unlimintAltCards.toList());
      localMethodsFilted = ObservableList.of(localMethods.toList());
      p2pMethodsFiltred = ObservableList.of(p2pMethods.toList());
    }

    if (cardsMethods.isEmpty) {
      sAnalytics.newBuyNoSavedCard();
    } else {
      // Проверяем что у нас есть хотя бы платежный метод как BANKCARD, и только тогда показываем карты юзеру
      if (getCardBuyMethod() != null) {
        cardSupportForThisAsset = true;
      }
    }
  }

  BuyMethodDto? getCardBuyMethod() {
    final cardIndex = cardsMethods
        .indexWhere((element) => element.id == PaymentMethodType.bankCard);

    return cardIndex != -1 ? cardsMethods[cardIndex] : null;
  }

  @computed
  bool get showSearch =>
      (cardsMethods.length + localMethods.length + p2pMethods.length) >= 7;

  @action
  void search(String value) {
    if (value.isEmpty) {
      searchList.clear();
    } else {
      searchList.clear();

      final cardF = cardsMethodsFiltred
          .where((element) => element.cardLabel?.contains(value) ?? false)
          .toList();
      final localF = localMethodsFilted
          .where((element) => element.id.name.contains(value) ?? false)
          .toList();
      final p2pF = p2pMethodsFiltred
          .where((element) => element.id.name.contains(value) ?? false)
          .toList();

      searchList.addAll(cardF
          .map((e) => PaymentMethodSearchModel(0, e.cardLabel ?? '', null, e))
          .toList());
      searchList.addAll(localF
          .map((e) => PaymentMethodSearchModel(1, e.id.name ?? '', e, null))
          .toList());
      searchList.addAll(p2pF
          .map((e) => PaymentMethodSearchModel(1, e.id.name ?? '', e, null))
          .toList());

      searchList.sort((a, b) => a.name.compareTo(b.name));
    }
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
    var dayState = asset.limits!.dayValue == asset.limits!.dayLimit
        ? StateLimitType.block
        : StateLimitType.active;
    var weekState = asset.limits!.weekValue == asset.limits!.weekLimit
        ? StateLimitType.block
        : StateLimitType.active;
    var monthState = asset.limits!.monthValue == asset.limits!.monthLimit
        ? StateLimitType.block
        : StateLimitType.active;
    if (monthState == StateLimitType.block) {
      finalProgress = 100;
      finalInterval = StateBarType.day30;
      weekState = weekState == StateLimitType.block
          ? StateLimitType.block
          : StateLimitType.none;
      dayState = dayState == StateLimitType.block
          ? StateLimitType.block
          : StateLimitType.none;
    } else if (weekState == StateLimitType.block) {
      finalProgress = 100;
      finalInterval = StateBarType.day7;
      dayState = dayState == StateLimitType.block
          ? StateLimitType.block
          : StateLimitType.none;
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
