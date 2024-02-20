import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
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

  @action
  Future<void> fetchClosedPositions() async {
    try {
      final response = await sNetwork.getWalletModule().getEarnPositionsClosed(
            skip: '0',
            take: '20',
          );
      final positions = response.data?.toList() ?? [];

      closedPositions.clear();
      closedPositions.addAll(positions);
    } catch (e) {
      //! Alex S. handle error
    }
  }

  @computed
  List<EarnOfferClientModel> get earnOffers {
    final offers = sSignalRModules.activeEarnOffersMessage?.offers.toList() ?? [];

    offers.sort((a, b) => (b.apyRate ?? Decimal.zero).compareTo(a.apyRate ?? Decimal.zero));

    return offers;
  }

  @computed
  bool get isBalanceHide => !getIt<AppStore>().isBalanceHide;

  @action
  Future<void> startEartWithdrawFlow({
    required EarnPositionClientModel earnPosition,
  }) async {
    if (earnPosition.withdrawType == WithdrawType.lock) {
      await _wirhdrawAllFlow();
    } else if (earnPosition.withdrawType == WithdrawType.instant) {
      await _wirhdrawPartialFlow(earnPosition: earnPosition);
    } else {
      sNotification.showError(
        intl.something_went_wrong,
        id: 1,
      );
    }
  }

  //TODO (yaroslav): complete function with task SPU-4264
  Future<void> _wirhdrawAllFlow() async {
    final context = sRouter.navigatorKey.currentContext!;

    await sShowAlertPopup(
      context,
      primaryText: intl.earn_are_you_sure,
      secondaryText: intl.earn_your_funds_and_accrued('12.12.2024'),
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
      },
    );
  }

  Future<void> _wirhdrawPartialFlow({
    required EarnPositionClientModel earnPosition,
  }) async {
    await sRouter.push(
      EarnWithdrawnTypeRouter(earnPosition: earnPosition),
    );
  }
}
