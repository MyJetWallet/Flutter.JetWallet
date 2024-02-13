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
  List<EarnPositionClientModel> get earnPositions => sSignalRModules.activeEarnPositionsMessage?.positions ?? [];

  /// Reflects the best (necessary) offers [EarnOfferClientModel] with
  ///  the status EarnOffers.Promotion == true
  @computed
  List<EarnOfferClientModel> get earnPromotionOffers =>
      sSignalRModules.activeEarnOffersMessage?.offers
          .where(
            (offer) => offer.promotion == true,
          )
          .toList() ??
      [];

  @computed
  bool get isBalanceHide => !getIt<AppStore>().isBalanceHide;
}
