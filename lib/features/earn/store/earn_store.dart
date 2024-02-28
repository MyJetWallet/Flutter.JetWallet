import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/earn/screens/earn_withdrawn_type_screen.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

part 'earn_store.g.dart';

class EarnStore extends _EarnStoreBase with _$EarnStore {
  EarnStore() : super();

  static _EarnStoreBase of(BuildContext context) => Provider.of<EarnStore>(context, listen: false);
}

abstract class _EarnStoreBase with Store {
  _EarnStoreBase() {
    fetchClosedPositions();
  }

  final formatService = getIt.get<FormatService>();

  @computed
  List<EarnPositionClientModel> get earnPositions {
    final positions = sSignalRModules.activeEarnPositionsMessage?.positions ?? [];
    final offers = sSignalRModules.activeEarnOffersMessage?.offers ?? [];

    final sortedPositions = positions.map((position) {
      final associatedOffers = offers.where((offer) => offer.id == position.offerId).toList();

      final updatedPosition = position.copyWith(offers: associatedOffers);

      return updatedPosition;
    }).toList();

    sortedPositions.sort((a, b) {
      final maxApyA = a.offers
          .map((offer) => offer.apyRate ?? Decimal.zero)
          .reduce((value, element) => value > element ? value : element);
      final maxApyB = b.offers
          .map((offer) => offer.apyRate ?? Decimal.zero)
          .reduce((value, element) => value > element ? value : element);

      return maxApyB.compareTo(maxApyA);
    });

    return sortedPositions;
  }

  @observable
  ObservableList<EarnPositionClientModel> closedPositions = ObservableList<EarnPositionClientModel>.of([]);

  @computed
  List<EarnPositionClientModel> get earnPositionsClosed => closedPositions;

  @computed
  Decimal get positionsTotalValueInVaseCurrency {
    var sum = Decimal.zero;

    for (final position in earnPositions) {
      final baseAmount = formatService.convertOneCurrencyToAnotherOne(
        fromCurrency: position.assetId,
        fromCurrencyAmmount: position.baseAmount,
        toCurrency: sSignalRModules.baseCurrency.symbol,
        baseCurrency: sSignalRModules.baseCurrency.symbol,
        isMin: true,
      );
      sum += baseAmount;
    }

    return sum;
  }

  @computed
  Decimal get positionsTotalRevenueInVaseCurrency {
    var sum = Decimal.zero;

    for (final position in earnPositions) {
      final incomeAmount = formatService.convertOneCurrencyToAnotherOne(
        fromCurrency: position.assetId,
        fromCurrencyAmmount: position.incomeAmount,
        toCurrency: sSignalRModules.baseCurrency.symbol,
        baseCurrency: sSignalRModules.baseCurrency.symbol,
        isMin: true,
      );
      sum += incomeAmount;
    }

    return sum;
  }

  @computed
  Map<String, List<EarnOfferClientModel>> get groupedOffers {
    final activeOffersWithPromotion =
        earnOffers.where((o) => o.status == EarnOfferStatus.activeShow && o.promotion).toList();
    final activeOffersWithoutPromotion =
        earnOffers.where((o) => o.status == EarnOfferStatus.activeShow && !o.promotion).toList();

    activeOffersWithPromotion.sort((a, b) => b.apyRate!.compareTo(a.apyRate!));
    activeOffersWithoutPromotion.sort((a, b) => b.apyRate!.compareTo(a.apyRate!));

    final concatenatedOffers = activeOffersWithPromotion + activeOffersWithoutPromotion;

    final groupedOffers = groupBy(concatenatedOffers, (EarnOfferClientModel o) => o.assetId);
    return groupedOffers;
  }

  @observable
  int skip = 0;

  @observable
  bool hasMore = true;

  @action
  Future<void> fetchClosedPositions({int take = 20}) async {
    if (!hasMore) return;

    try {
      final response = await sNetwork.getWalletModule().getEarnPositionsClosed(
            skip: skip.toString(),
            take: take.toString(),
          );
      final positions = response.data?.toList() ?? [];

      if (positions.isNotEmpty) {
        closedPositions.addAll(positions);
        skip += positions.length;
      }
    } catch (e) {
      hasMore = false;
      //! Alex S. handle error
    }
  }

  @action
  void resetPagination() {
    skip = 0;
    hasMore = true;
    closedPositions.clear();
  }

  @computed
  List<EarnOfferClientModel> get earnOffers {
    final offers = sSignalRModules.activeEarnOffersMessage?.offers.toList() ?? [];

    offers.sort((a, b) => (b.apyRate ?? Decimal.zero).compareTo(a.apyRate ?? Decimal.zero));

    return offers;
  }

  @computed
  Map<String, List<EarnOfferClientModel>> get filteredOffersGroupedByCurrency {
    final currencies = sSignalRModules.currenciesList;

    final offersGroupedByCurrency = groupBy(earnOffers, (EarnOfferClientModel offer) {
      return currencies.firstWhereOrNull((currency) => currency.symbol == offer.assetId)?.description ?? '';
    });

    final filtered = Map<String, List<EarnOfferClientModel>>.fromEntries(
      offersGroupedByCurrency
          .map((currencyDescription, List<EarnOfferClientModel> offers) {
            final anyPromotionalOfferExists = offers.any((offer) => offer.promotion);
            return MapEntry(currencyDescription, anyPromotionalOfferExists ? offers : <EarnOfferClientModel>[]);
          })
          .entries
          .where((entry) => entry.value.isNotEmpty)
          .map((entry) => MapEntry(entry.key, entry.value)),
    );

    return filtered;
  }

  @computed
  Map<String, EarnOfferClientModel> get highestApyOffersPerCurrency {
    final currencies = sSignalRModules.currenciesList;
    final earnOffers = sSignalRModules.activeEarnOffersMessage?.offers ?? [];

    final offersGroupedByCurrency = groupBy(earnOffers, (EarnOfferClientModel offer) {
      return currencies.firstWhereOrNull((currency) => currency.symbol == offer.assetId)?.description ?? '';
    });

    final highestApyOffers = <String, EarnOfferClientModel>{};
    offersGroupedByCurrency.forEach((description, offers) {
      final highestApyOffer = offers.reduce(
        (curr, next) => (curr.apyRate ?? Decimal.zero) > (next.apyRate ?? Decimal.zero) ? curr : next,
      );
      highestApyOffers[description] = highestApyOffer;
    });

    return highestApyOffers;
  }

  @computed
  bool get isBalanceHide => !getIt<AppStore>().isBalanceHide;

  @action
  Future<void> startEartWithdrawFlow({
    required EarnPositionClientModel earnPosition,
  }) async {
    if (earnPosition.withdrawType == WithdrawType.lock) {
      await _wirhdrawAllFlow(earnPosition: earnPosition);
    } else if (earnPosition.withdrawType == WithdrawType.instant) {
      await _wirhdrawPartialFlow(earnPosition: earnPosition);
    } else {
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );
    }
  }

  Future<void> _wirhdrawAllFlow({
    required EarnPositionClientModel earnPosition,
  }) async {
    final context = sRouter.navigatorKey.currentContext!;

    final closeDate = DateTime.now().add(Duration(days: earnPosition.offers.first.lockPeriod ?? 0));
    final formatedData = formatDateToDMYFromDate(closeDate.toString());

    await sShowAlertPopup(
      context,
      primaryText: intl.earn_are_you_sure,
      secondaryText: intl.earn_your_funds_and_accrued(formatedData),
      primaryButtonName: intl.earn_continue_earning,
      secondaryButtonName: intl.earn_yes_withdraw,
      image: Image.asset(
        infoLightAsset,
        width: 80,
        height: 80,
        package: 'simple_kit',
      ),
      onPrimaryButtonTap: () {
        sRouter.pop();
      },
      onSecondaryButtonTap: () {
        sRouter.pop();
        sRouter.push(
          EarnWithdrawOrderSummaryRouter(
            amount: earnPosition.baseAmount + earnPosition.incomeAmount,
            earnPosition: earnPosition,
            isClosing: true,
          ),
        );
      },
    );
  }

  Future<void> _wirhdrawPartialFlow({
    required EarnPositionClientModel earnPosition,
  }) async {
    if (earnPosition.baseAmount > (earnPosition.offers.first.minAmount ?? Decimal.zero)) {
      await sRouter.push(
        EarnWithdrawnTypeRouter(earnPosition: earnPosition),
      );
    } else {
      await showWithdrawalTypeAreYouSurePopUp(
        amount: earnPosition.baseAmount + earnPosition.incomeAmount,
        earnPosition: earnPosition,
      );
    }
  }
}
