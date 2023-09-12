import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/rewards_profile_model.dart';
part 'rewards_flow_store.g.dart';

class RewardsFlowStore extends _RewardsFlowStoreBase with _$RewardsFlowStore {
  RewardsFlowStore() : super();

  static RewardsFlowStore of(BuildContext context) =>
      Provider.of<RewardsFlowStore>(context, listen: false);
}

abstract class _RewardsFlowStoreBase with Store {
  _RewardsFlowStoreBase() {
    reaction<RewardsProfileModel?>(
      (_) => sSignalRModules.rewardsData,
      (RewardsProfileModel? data) {
        if (data != null) {
          updateData(data);
        }
      },
    );
  }

  @observable
  int availableSpins = 0;

  @observable
  Decimal totalEarnedUsd = Decimal.zero;

  @observable
  Decimal totalEarnedBaseCurrency = Decimal.zero;

  @observable
  ObservableList<RewardsBalance> balances = ObservableList.of([]);

  @action
  void updateData(RewardsProfileModel data) {
    availableSpins = data.availableSpins ?? 0;
    totalEarnedUsd = data.totalEarnedUsd ?? Decimal.zero;
    totalEarnedBaseCurrency = data.totalEarnedBaseCurrency ?? Decimal.zero;
    balances = ObservableList.of(data.balances ?? []);
  }
}
