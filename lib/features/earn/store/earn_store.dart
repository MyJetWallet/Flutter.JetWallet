import 'package:decimal/decimal.dart';
import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
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

  /// Reflects the best (necessary) offers [EarnOfferClientModel] with
  ///  the status EarnOffers.Promotion == true
  @computed
  List<EarnOfferClientModel> get earnPromotionOffers {
    final offers =
        sSignalRModules.activeEarnOffersMessage?.offers.where((offer) => offer.promotion == true).toList() ?? [];

    offers.sort((a, b) => (b.apyRate ?? Decimal.zero).compareTo(a.apyRate ?? Decimal.zero));

    return offers;
  }

  @computed
  bool get isBalanceHide => !getIt<AppStore>().isBalanceHide;
}